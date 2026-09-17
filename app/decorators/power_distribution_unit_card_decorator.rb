# frozen_string_literal: true

class PowerDistributionUnitCardDecorator < ApplicationDecorator
  class << self
    include ActionView::Helpers::FormOptionsHelper

    def card_type_grouped_by_port_type_options_for_select(selected = nil)
      grouped_card_types = PortType
        .usable_by_pdu
        .includes(:card_types)
        .map do |port_type|
          [port_type.to_s, port_type.card_types.map { |card_type| [card_type.to_s, card_type.id] }]
      end

      grouped_options_for_select(grouped_card_types, selected)
    end
  end
end
