# frozen_string_literal: true

class CardAbstract < ApplicationRecord
  self.abstract_class = true

  ORIENTATIONS = %i[lr-td rl-td dt-lr td-lr].freeze

  belongs_to :card_type

  delegate :port_quantity, to: :card_type, allow_nil: true
  delegate :is_power?, to: :card_type, allow_nil: true

  has_many :ports, as: :attachable, dependent: :destroy
  has_many :cables, through: :ports
  has_many :connections, through: :ports, source: "connections"

  validates :first_position, numericality: { only_integer: true, in: 0..100 }, allow_nil: true
  validate :ensure_card_type_have_enough_ports

  def first_port_position
    first_position.presence || card_type&.first_position.presence || 1
  end

  def positions_with_ports
    ports.map(&:position)
  end

  def create_missing_ports
    (1..port_quantity).without(positions_with_ports).each do |current_position|
      Port.create(position: current_position,
                  attachable: self,
                  vlans: nil,
                  color: nil,
                  cablename: nil)
    end
  end

  private

  def ensure_card_type_have_enough_ports
    port_quantity = card_type&.port_quantity || 0

    errors.add(:card_type_id, :not_enough_ports) if connections.count > port_quantity
  end
end
