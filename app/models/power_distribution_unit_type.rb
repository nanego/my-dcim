# frozen_string_literal: true

class PowerDistributionUnitType < ApplicationRecord
  belongs_to :manufacturer

  enum :current_type, { three_phase: 0, single_phase: 1 }

  validates :name, presence: true
  validates :documentation_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  delegate :to_s, to: :name
end
