# frozen_string_literal: true

class PowerDistributionUnit
  class Circuit < ApplicationRecord
    has_changelog

    belongs_to :record, polymorphic: true

    validates :name, presence: true
  end
end
