# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  belongs_to :type, class_name: "PowerDistributionUnitType"
  belongs_to :bay
end
