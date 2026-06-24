# frozen_string_literal: true

class PowerDistributionUnitSocketDecorator < ApplicationDecorator
  class << self
    def alim_port_type_options_for_select
      PortTypeDecorator.alim_options_for_select
    end
  end
end
