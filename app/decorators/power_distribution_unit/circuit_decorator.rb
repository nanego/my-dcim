# frozen_string_literal: true

class PowerDistributionUnit
  class CircuitDecorator < ApplicationDecorator
    class << self
      def options_for_select(collection = Circuit.all)
        collection.pluck(:name, :id)
      end
    end
  end
end
