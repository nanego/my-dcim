# frozen_string_literal: true

class PowerDistributionUnitDecorator < ApplicationDecorator
  class << self
    def islets_options_for_select(user)
      IsletDecorator.options_for_select(user)
    end
  end
end
