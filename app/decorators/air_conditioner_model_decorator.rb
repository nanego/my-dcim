# frozen_string_literal: true

class AirConditionerModelDecorator < ApplicationDecorator
  class << self
    def manufacturers_options_for_select
      ManufacturerDecorator.options_for_select
    end
  end
end
