# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :circuit, source: :record, source_type: "PowerDistributionUnit"

    validates :number, presence: true
    validate :number_unique_within_pdu_or_pdu_type

    private

    def number_unique_within_pdu_or_pdu_type
      return unless circuit

      errors.add(:number, :taken) if circuit.record.sockets
        .where(number:)
        .where.not(id:)
        .any?
    end
  end
end
