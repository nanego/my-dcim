# frozen_string_literal: true

class PowerDistributionUnitSocketDecorator < ApplicationDecorator
  class << self
    delegate :grouped_by_port_type_options_for_select, to: :CardTypeDecorator
  end
end
