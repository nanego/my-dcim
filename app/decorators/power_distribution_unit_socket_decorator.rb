# frozen_string_literal: true

class PowerDistributionUnitSocketDecorator < ApplicationDecorator
  class << self
    def port_types_options_for_select
      PortTypeDecorator.options_for_select(PortType.power_ones.usable_by_pdu)
    end
  end
end
