# frozen_string_literal: true

class PowerDistributionUnitType < ApplicationRecord
  has_changelog

  belongs_to :manufacturer

  enum :current_type, { three_phase: 0, single_phase: 1 }, validate: true

  scope :sorted, -> { order(Arel.sql("LOWER(name)")) }

  validates :name, presence: true
  validates :documentation_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  delegate :to_s, to: :name
end
