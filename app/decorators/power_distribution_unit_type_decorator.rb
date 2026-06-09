# frozen_string_literal: true

class PowerDistributionUnitTypeDecorator < ApplicationDecorator
  class << self
    def options_for_select
      PowerDistributionUnitType.select(:id, :name).sorted.map { |r| [r.to_s, r.id] }
    end

    def manufacturers_options_for_select
      ManufacturerDecorator.options_for_select
    end

    def current_type_options_for_select
      PowerDistributionUnitType.current_types.keys.map do |c_t|
        [PowerDistributionUnitType.human_attribute_name("current_type.#{c_t}"), c_t]
      end
    end
  end
end
