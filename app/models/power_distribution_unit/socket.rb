# frozen_string_literal: true

class PowerDistributionUnit
  class Socket < ApplicationRecord
    has_changelog

    acts_as_list scope: [:block_id]

    belongs_to :block

    belongs_to :circuit
    belongs_to :port_type

    has_one :port, as: :attachable, dependent: :destroy
    has_one :power_distribution_unit, through: :block, source: :record, source_type: "PowerDistributionUnit"

    validates :name, presence: true
    validates :position, presence: true
    validate :position_uniqueness

    def create_missing_ports
      Port.create(attachable: self)
    end

    private

    def position_uniqueness
      return unless block

      return unless block.record.sockets
        .where(position:)
        .where.not(id:)
        .any?

      errors.add(:position, :taken)
    end
  end
end
