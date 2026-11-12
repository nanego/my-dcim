# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    belongs_to :block
    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :block, source: :record, source_type: "PowerDistributionUnit"

    validates :number, presence: true
    validate :number_unique

    def create_missing_ports
      Port.create(attachable: self)
    end

    private

    def number_unique
      return unless block.record.sockets
        .where(number:)
        .where.not(id:)
        .any?

      errors.add(:number, :taken)
    end
  end
end
