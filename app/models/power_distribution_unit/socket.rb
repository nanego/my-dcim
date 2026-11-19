# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    # TODO: uncomment when block are merged
    # acts_as_list scope: [:block_id]

    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :circuit, source: :record, source_type: "PowerDistributionUnit"

    validates :name, presence: true
    validates :position, presence: true
    validate :position_unique_within_power_distribution_unit

    def create_missing_ports
      Port.create(attachable: self)
    end

    private

    def position_unique_within_power_distribution_unit
      return unless power_distribution_unit

      errors.add(:position, :taken) if power_distribution_unit.sockets
        .where(position:)
        .where.not(id:)
        .any?
    end
  end
end
