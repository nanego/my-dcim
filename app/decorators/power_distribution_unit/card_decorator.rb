# frozen_string_literal: true

class PowerDistributionUnit
  class CardDecorator < ApplicationDecorator
    class << self
      include ActionView::Helpers::FormOptionsHelper

      def card_type_grouped_by_port_type_options_for_select
        PortType
          .includes(:card_types)
          .map do |port_type|
            [port_type.to_s, port_type.card_types.map { |card_type| [card_type.to_s, card_type.id] }]
        end
      end
    end
  end
end
