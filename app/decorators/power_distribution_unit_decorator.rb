# frozen_string_literal: true

class PowerDistributionUnitDecorator < ApplicationDecorator
  class << self
    def power_distribution_unit_types_options_for_select
      PowerDistributionUnitTypeDecorator.options_for_select
    end

    def bays_options_for_select(user)
      BayDecorator.options_for_select(user)
    end

    def side_options_for_select
      PowerDistributionUnit.sides.keys.map do |c_t|
        [PowerDistributionUnit.human_attribute_name("side.#{c_t}"), c_t]
      end
    end

    def orientation_options_for_select
      PowerDistributionUnit.orientations.keys.map do |c_t|
        [PowerDistributionUnit.human_attribute_name("orientation.#{c_t}"), c_t]
      end
    end
  end
end
