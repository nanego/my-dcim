# frozen_string_literal: true

class PowerDistributionUnit
  class SocketDecorator < ApplicationDecorator
    class << self
      def port_types_options_for_select
        PortTypeDecorator.options_for_select(PortType.power_ones)
      end

      def circuits_options_for_select(socket)
        CircuitDecorator.options_for_select(socket.block.record.circuits)
      end
    end
  end
end
