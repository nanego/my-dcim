# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  extend FriendlyId

  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog associations: { circuits: "*", sockets: "*" }

  belongs_to :type, class_name: "PowerDistributionUnitType"
  belongs_to :frame

  has_many :circuits, as: :record, class_name: "PowerDistributionUnit::Circuit", dependent: :destroy
  has_many :sockets, class_name: "PowerDistributionUnit::Socket", through: :circuits
  has_many :cards, as: :record, class_name: "PowerDistributionUnit::Card", dependent: :destroy
  has_many :sockets_ports, class_name: "Port", through: :sockets, source: :port
  has_many :cards_ports, class_name: "Port", through: :cards, source: :ports
  has_many :sockets_cables, class_name: "Cable", through: :sockets_ports, source: :cable
  has_many :cards_cables, class_name: "Cable", through: :cards_ports, source: :cable

  has_one :manufacturer, through: :type
  has_one :bay, through: :frame
  has_one :islet, through: :frame
  has_one :room, through: :frame
  has_one :site, through: :room

  enum :orientation, { asc: 0, desc: 1 }, validate: true
  enum :side, { left: 0, right: 1 }, validate: true
  enum :power_line, { a: "a", b: "b" }, validates: true

  validates :serial_number, presence: true, uniqueness: true, format: { without: /\s/ }
  validates :power_line, uniqueness: { scope: :frame_id }
  validates :ipmi_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  accepts_nested_attributes_for :circuits, allow_destroy: true
  accepts_nested_attributes_for :cards, allow_destroy: true

  delegate :to_s, to: :name
  delegate :phases_count, to: :type

  before_create :build_circuits_and_sockets_from_type
  before_create :build_cards_from_type

  def should_generate_new_friendly_id?
    return true if slug.blank? || power_line_changed?

    frame_name = frame&.name
    frame_name.nil? || !slug.starts_with?(frame.name)
  end

  def name
    "#{frame&.name}-#{power_line&.upcase}"
  end

  def deep_dup
    copy = dup

    copy.tap do |pdu|
      pdu.circuits = circuits.map(&:deep_dup)
    end
  end

  def circuits_per_phase
    circuits.size / phases_count
  end

  def ports
    Port.where(id: sockets_ports.select(:id))
      .or(Port.where(id: cards_ports.select(:id)))
  end

  def cables
    Cable.where(id: sockets_cables.select(:id))
      .or(Cable.where(id: cards_cables.select(:id)))
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end

  def build_circuits_and_sockets_from_type
    self.circuits = type.circuits.map(&:deep_dup)
  end

  def build_cards_from_type
    self.cards = type.cards.map(&:dup)
  end
end
