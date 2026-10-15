# frozen_string_literal: true

class Server < ApplicationRecord # rubocop:disable Metrics/ClassLength
  extend FriendlyId

  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog associations: { cards: "*" }

  belongs_to :frame
  belongs_to :manager, optional: true, counter_cache: true
  belongs_to :domain, optional: true, counter_cache: true
  belongs_to :cluster, optional: true, counter_cache: true
  belongs_to :stack, optional: true, counter_cache: true
  belongs_to :modele, counter_cache: true

  has_one :bay, through: :frame
  has_one :islet, through: :frame
  has_one :room, through: :islet
  has_one :site, through: :room
  has_one :manufacturer, through: :modele

  has_many :cards, -> { joins(:composant).includes(:composant) }, dependent: :destroy
  has_many :card_types, through: :cards
  has_many :ports, through: :cards
  has_many :connections, through: :ports, source: :connection
  has_many :cables, through: :connections
  has_many :moves, as: :moveable, dependent: :destroy
  has_many :documents, dependent: :restrict_with_error
  has_many :external_app_records, dependent: :destroy

  has_one_attached :photo

  validates :numero, presence: true, uniqueness: true
  validates :numero, format: { without: /\s/ }
  validates :name, presence: true
  validate :numero_cannot_be_a_current_server_name
  validate :validate_network_types_values
  # Only checked when a user types the position in a form
  validate :rack_units_within_frame, :rack_units_available, on: :rack_placement, if: :rack_placement_changed?

  accepts_nested_attributes_for :cards,
                                allow_destroy: true,
                                reject_if: :all_blank
  accepts_nested_attributes_for :documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  normalizes :network_types, with: ->(values) { values.compact_blank }
  normalizes :numero, with: ->(numero) { numero.presence }

  before_create :set_default_network_types

  scope :sorted, -> { order(position: :desc) }
  scope :sorted_by_name, -> { order("LOWER(name) ASC") }

  scope :glpi_synchronizable, -> { joins(modele: :category).merge(Modele.glpi_synchronizable) }
  scope :no_pdus, -> { joins(modele: :category).where("categories.name<>'Pdu'") }
  scope :only_pdus, -> { joins(modele: :category).where("categories.name='Pdu'").order(:name) }
  scope :patch_panels, -> { joins(modele: :category).where("categories.name='Patch Panel'").order(:name) }

  def self.friendly_find_by_numero_or_name(name)
    name = name.to_s.downcase

    Server.find_by("lower(numero) = ?", name) || Server.friendly.find(name)
  end

  delegate :to_s, to: :name

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def is_a_pdu?
    modele&.is_a_pdu?
  end

  def is_not_a_pdu?
    !is_a_pdu?
  end

  def ports_per_type
    # Number of ports per type
    sums = { "XRJ" => 0, "RJ" => 0, "FC" => 0, "IPMI" => 0 }
    cards.each do |card|
      port_type = if card.composant.name == "IPMI"
                    "IPMI"
                  else
                    card.card_type.port_type.name
                  end
      sums[port_type] = sums[port_type].to_i + card.ports.filter_map { |port| port.connection.try(:cable) }.size
    end
    sums
  end

  def create_missing_ports
    cards.each(&:create_missing_ports)
  end

  def connected_servers_ids_through_twin_cards_with_color
    connections = directly_connected_servers_ids_with_color
    connected_ports.each do |port|
      if port.card&.twin_card_id
        twin_card = Card.find(port.card.twin_card_id)
        twin_card_port = twin_card.ports.includes(:connection).where(position: port.position).first
        if twin_card_port&.paired_connection
          connections << { server_id: twin_card_port.paired_connection.port.server_id, cable_color: twin_card_port.paired_connection.try(:cable).try(:color) }
        end
        connections << { server_id: twin_card.server_id, cable_color: twin_card_port.try(:connection).try(:cable).try(:color) }
      end
    end
    connections
  end

  def directly_connected_servers_ids
    connected_ports.map(&:server_id)
  end

  def directly_connected_servers_ids_with_color
    connected_ports.filter_map do |port|
      if port.card.present?
        { server_id: port.server_id, cable_color: port.connection.try(:cable).try(:color) }
      end
    end
  end

  def connected_ports
    distant_connections.filter_map(&:port)
  end

  def distant_connections
    cables_ids = ports.includes(connection: [:cable]).filter_map(&:connection).map(&:cable).map(&:id)
    Connection.includes(:cable, :port, :card).joins(:cable).where(cable_id: cables_ids).where.not(port_id: ports.map(&:id)).where.not(port_id: nil)
  end

  def documentation_url
    return unless modele&.manufacturer&.documentation_url.present? && numero.present?

    format(modele&.manufacturer&.documentation_url, numero)
  end

  # Position is the top U of the equipment, which spans modele.u units downwards.
  def height_in_u
    modele&.u.to_i.positive? ? modele.u : 1
  end

  def rack_units
    return if position.blank?

    (position - height_in_u + 1)..position
  end

  def rack_units_label
    return if rack_units.nil?

    rack_units.one? ? "U#{position}" : "U#{rack_units.first}-#{rack_units.last}"
  end

  def overlapping_servers
    return Server.none if rack_units.nil? || frame_id.blank?

    Server.joins(:modele)
      .where(frame_id:)
      .where.not(id:)
      .where(position: rack_units.first..)
      .where("servers.position - COALESCE(NULLIF(modeles.u, 0), 1) + 1 <= ?", rack_units.last)
  end

  def deep_dup
    copy = dup

    copy.tap do |server|
      server.cards = cards.map(&:dup)
    end
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end

  def numero_cannot_be_a_current_server_name
    servers = Server.friendly.where(slug: numero.to_s.downcase) - [self]

    errors.add(:numero, :same_as_server_name) if servers.present?
  end

  def set_default_network_types
    return unless network_types && network_types.empty?
    return if modele.blank?

    self.network_types = modele.network_types
  end

  def rack_placement_changed?
    position_changed? || frame_id_changed? || modele_id_changed?
  end

  def rack_units_within_frame
    return if rack_units.nil?
    return if rack_units.first >= 1 && (frame&.u.blank? || position <= frame.u)

    errors.add(:position, :outside_frame, units: rack_units_label)
  end

  def rack_units_available
    servers = overlapping_servers.order(position: :desc).pluck(:name)
    return if servers.empty?

    errors.add(:position, :overlaps, units: rack_units_label, servers: servers.to_sentence)
  end

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.intersect?(Modele::Network::TYPES)

    errors.add(:network_types, :invalid)
  end
end
