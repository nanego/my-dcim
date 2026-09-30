# frozen_string_literal: true

class PowerDistributionUnit
  class SocketDecorator < ApplicationDecorator
    class << self
      def port_types_options_for_select
        PortTypeDecorator.options_for_select(PortType.power_ones)
      end
    end
  end
end
