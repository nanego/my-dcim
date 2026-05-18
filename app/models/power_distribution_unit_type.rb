# frozen_string_literal: true

class PowerDistributionUnitType < ApplicationRecord
  belongs_to :manufacturer

  enum :current_type, { three_phase: 0, single_phase: 1 }
end
