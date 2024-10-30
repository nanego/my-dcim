# frozen_string_literal: true

class Card < ApplicationRecord
  ORIENTATIONS = %i[lr-td rl-td dt-lr td-lr]

  has_changelog

  belongs_to :card_type
  delegate :port_quantity, to: :card_type, allow_nil: true
  delegate :is_power_input?, to: :card_type, allow_nil: true

  belongs_to :server
  belongs_to :composant
  delegate :frame, to: :server # TODO: replace by has_one?

  has_many :ports
  has_many :cables, through: :ports

  validates :first_position, numericality: { only_integer: true, in: 1...100 }, allow_nil: true

  after_commit :set_twin_card

  scope :on_patch_panels, -> () { joins(:server => { :modele => :category }).where("categories.name = 'Patch Panel'") }

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

  def first_port_position
    if first_position.present?
      first_position
    else
      if card_type.present? && card_type.first_position.present?
        card_type.first_position
      else
        1
      end
    end
  end

  def positions_with_ports
    ports.map { |port| port.position }
  end

  def create_missing_ports
    (1..port_quantity).each do |current_position|
      unless positions_with_ports.include?(current_position)
        puts "create port #{current_position}"
        Port.create(position: current_position,
                    card_id: self.id,
                    vlans: nil,
                    color: nil,
                    cablename: nil)
      end
    end
  end

  def set_twin_card
    if twin_card_id.present?
      twin_card = Card.where(id: twin_card_id).first
      if twin_card.present? && twin_card.twin_card_id.blank?
        twin_card.twin_card_id = self.id
        twin_card.save
      end
      # Remove potential duplications
      Card.where(twin_card_id: [self.id, twin_card_id])
        .where.not(id: [self.id, twin_card_id])
        .update_all({ twin_card_id: nil }) # rubocop:disable Rails/SkipsModelValidations
    end
  end
end
