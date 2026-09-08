# frozen_string_literal: true

class Card < CardAbstract
  has_changelog

  belongs_to :server, touch: true
  belongs_to :composant
  belongs_to :twin_card, class_name: "Card", optional: true

  delegate :frame, to: :server # TODO: replace by has_one?

  after_commit :set_twin_card

  scope :on_patch_panels, -> { joins(server: { modele: :category }).where("categories.name = 'Patch Panel'") }

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

  private

  def set_twin_card
    return if twin_card_id.blank?

    twin_card = Card.where(id: twin_card_id).first
    if twin_card.twin_card_id != id
      twin_card.twin_card_id = id
      twin_card.save
    end

    # Remove potential duplications
    Card.where(twin_card_id: [id, twin_card_id])
      .where.not(id: [id, twin_card_id])
      .update_all({ twin_card_id: nil }) # rubocop:disable Rails/SkipsModelValidations
  end
end
