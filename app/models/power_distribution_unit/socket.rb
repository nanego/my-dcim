# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :circuit, source: :record, source_type: "PowerDistributionUnit"

    validates :number, presence: true
  end
end
