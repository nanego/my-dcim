# frozen_string_literal: true

class PowerDistributionUnitSocketDecorator < ApplicationDecorator
  class << self
    def port_type_options_for_select
      PortTypeDecorator.options_for_select(PortType.where(power: true))
    end
  end
end
