# frozen_string_literal: true

class PowerDistributionUnit
  class Circuit < ApplicationRecord
    ALLOWED_MAX_CURRENT_VALUES = [10, 16, 20, 25, 32, 40, 63].freeze

    has_changelog

    belongs_to :record, polymorphic: true
    has_many :sockets, dependent: :destroy

    enum :phase, { L1: 1, L2: 2, L3: 3 }, prefix: true, allow_nil: true

    validates :max_current, inclusion: { in: ALLOWED_MAX_CURRENT_VALUES }, if: :max_current
    validates :name, presence: true
  end
end
