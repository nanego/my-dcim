# frozen_string_literal: true

class PowerDistributionUnitType < ApplicationRecord
  has_changelog

  belongs_to :manufacturer
  has_many :power_distribution_units, dependent: :restrict_with_error, foreign_key: :type_id, inverse_of: :type

  has_many :circuits, as: :record, dependent: :destroy

  enum :current_type, { three_phase: 0, single_phase: 1 }, validate: true

  scope :sorted, -> { order(Arel.sql("LOWER(name)")) }

  accepts_nested_attributes_for :circuits,
                                allow_destroy: true,
                                reject_if: :all_blank

  validates :name, presence: true
  validates :documentation_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  delegate :to_s, to: :name
end
