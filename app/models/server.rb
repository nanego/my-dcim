# frozen_string_literal: true

class Server < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  belongs_to :frame
  has_one :bay, through: :frame
  has_one :islet, through: :frame
  has_one :room, through: :islet
  belongs_to :gestion, optional: true, counter_cache: true
  belongs_to :domaine, optional: true, counter_cache: true
  belongs_to :modele, counter_cache: true
  belongs_to :cluster, optional: true, counter_cache: true
  belongs_to :server_state, optional: true
  belongs_to :stack, optional: true, counter_cache: true

  has_many :memory_components
  has_many :disks

  has_many :cards, -> { joins(:composant).includes(:composant) }
  has_many :card_types, through: :cards
  has_many :ports, through: :cards
  has_many :connections, through: :ports
  has_many :cables, through: :connections

  has_many :moves, as: :moveable, dependent: :destroy

  has_many :documents, dependent: :restrict_with_error
  has_one_attached :photo

  has_many :external_app_record, dependent: :destroy

  validates_presence_of :numero
  validates :name, presence: true
  validates_uniqueness_of :numero
  validate :numero_cannot_be_a_current_server_name
  validate :validate_network_types_values

  accepts_nested_attributes_for :cards,
                                allow_destroy: true,
                                reject_if: :all_blank
  accepts_nested_attributes_for :disks,
                                allow_destroy: true,
                                reject_if: :all_blank
  accepts_nested_attributes_for :memory_components,
                                allow_destroy: true,
                                reject_if: :all_blank
  accepts_nested_attributes_for :documents,
                                allow_destroy: true,
                                reject_if: :all_blank

  normalizes :network_types, with: ->(values) { values.compact_blank }

  before_create :set_default_network_types

  scope :sorted, -> { order(position: :desc) }
  scope :sorted_by_name, -> { order('LOWER(name) ASC') }

  scope :glpi_synchronizable, -> { joins(modele: :category).merge(Modele.glpi_synchronizable) }
  scope :no_pdus, -> { joins(modele: :category).where("categories.name<>'Pdu'") }
  scope :only_pdus, -> { joins(modele: :category).where("categories.name='Pdu'").order(:name) }
  scope :patch_panels, -> { joins(modele: :category).where("categories.name='Patch Panel'").order(:name) }

  scope :search, lambda { |query|
    return if query.blank?

    joins(modele: :manufacturer).where(
      'servers.name ILIKE :query OR
      servers.numero ILIKE :query OR
      modeles.name ILIKE :query OR
      manufacturers.name ILIKE :query',
      query: "%#{query}%"
    )
  }

  def self.friendly_find_by_numero_or_name(name)
    name = name.to_s.downcase

    Server.find_by('lower(numero) = ?', name) || Server.friendly.find(name)
  end

  def to_s
    name.to_s
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  def is_a_pdu?
    modele.is_a_pdu?
  end

  def is_not_a_pdu?
    !is_a_pdu?
  end

  def ports_per_type
    # Number of ports per type
    sums = { 'XRJ' => 0, 'RJ' => 0, 'FC' => 0, 'IPMI' => 0 }
    cards.each do |card|
      if card.composant.name == 'IPMI'
        port_type = 'IPMI'
      else
        port_type = card.card_type.port_type.name
      end
      sums[port_type] = sums[port_type].to_i + card.ports.map { |port| port.connection.try(:cable) }.compact.size
    end
    sums
  end

  def create_missing_ports
    cards.each { |card| card.create_missing_ports }
  end

  def connected_servers_ids_through_twin_cards_with_color
    connections = directly_connected_servers_ids_with_color
    connected_ports.each do |port|
      if port.card&.twin_card_id
        twin_card = Card.find(port.card.twin_card_id)
        twin_card_port = twin_card.ports.includes(:connection).where(position: port.position).first
        if twin_card_port
          connections << { server_id: twin_card_port.paired_connection.port.server_id, cable_color: twin_card_port.paired_connection.try(:cable).try(:color) } if twin_card_port.paired_connection
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
    connected_ports.map do |port|
      if port.card.present?
        { server_id: port.server_id, cable_color: port.connection.try(:cable).try(:color) }
      end
    end.compact
  end

  def connected_ports
    distant_connections.map(&:port).reject(&:nil?)
  end

  def distant_connections
    cables_ids = ports.includes(:connection => [:cable]).map(&:connection).reject(&:nil?).map(&:cable).map(&:id)
    Connection.includes(:cable, :port => [:card]).joins(:cable).where(cable_id: cables_ids).where.not(port_id: ports.map(&:id)).where('port_id IS NOT NULL')
  end

  def documentation_url
    return unless modele&.manufacturer&.documentation_url.present? && numero.present?

    format(modele&.manufacturer&.documentation_url, numero)
  end

  def deep_dup
    copy = dup

    copy.tap do |server|
      server.cards = cards.map(&:dup)
    end
  end

  def destroy_connections!
    transaction do
      cables.find_each(&:destroy!)
    end

    true
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

    errors.add(:numero, :invalid) if servers.present?
  end

  def set_default_network_types
    return unless network_types && network_types.empty?
    return if modele.blank?

    self.network_types = modele.network_types
  end

  def validate_network_types_values
    return if network_types.empty?
    return if network_types.any? { |n| Modele::Network::TYPES.include?(n) }

    errors.add(:network_types, :invalid)
  end
end
