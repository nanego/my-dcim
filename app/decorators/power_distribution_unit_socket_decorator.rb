# frozen_string_literal: true

class PowerDistributionUnitSocketDecorator < ApplicationDecorator
  class << self
    def port_types_options_for_select
      PortTypeDecorator.options_for_select(PortType.with_usable_by(:pdu))
    end
  end
end
