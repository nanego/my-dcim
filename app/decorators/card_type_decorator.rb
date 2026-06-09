# frozen_string_literal: true

class CardTypeDecorator < ApplicationDecorator
  class << self
    include ActionView::Helpers::FormOptionsHelper

    def grouped_by_port_type_options_for_select(selected = nil)
      grouped_card_types = CardType.includes(:port_type)
        .sorted
        .group_by(&:port_type)
        .map do |port_type, card_types|
          [port_type.to_s, card_types.map { |card_type| [card_type.to_s, card_type.id] }]
      end

      grouped_options_for_select(grouped_card_types, selected)
    end
  end
end
