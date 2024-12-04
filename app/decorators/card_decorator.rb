# frozen_string_literal: true

class CardDecorator < ApplicationDecorator
  class << self
    def card_options_for_select
      Card.includes(:composant, :card_type).order(:name, "composants.name", "card_types.name").map do |card|
        [card.decorated.full_name, card.id]
      end
    end
  end

  def full_name
    @full_name ||= [name, composant, card_type].compact_blank.join(" / ")
  end
end
