# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  belongs_to :type_id
  belongs_to :bay_id
end
