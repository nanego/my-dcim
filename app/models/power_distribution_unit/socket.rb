# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    belongs_to :circuit
    belongs_to :port_type

    validates :number, presence: true
  end
end
