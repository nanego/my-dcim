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
    validates :position, presence: true, uniqueness: { scope: [:block_id] }
    validate :name_uniqueness

    def create_missing_ports
      Port.create(attachable: self)
    end

    private

    def name_uniqueness
      return unless block

      return unless block.record.sockets
        .where(name:)
        .where.not(id:)
        .any?

      errors.add(:name, :taken)
    end
  end
end
