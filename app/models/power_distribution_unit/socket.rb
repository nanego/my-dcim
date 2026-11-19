# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :circuit, source: :record, source_type: "PowerDistributionUnit"

    validates :number, presence: true
    validate :number_unique_within_power_distribution_unit

    def create_missing_ports
      Port.create(attachable: self)
    end

    private

    def number_unique_within_power_distribution_unit
      return unless power_distribution_unit

      errors.add(:number, :taken) if power_distribution_unit.sockets
        .where(number:)
        .where.not(id:)
        .any?
    end
  end
end
