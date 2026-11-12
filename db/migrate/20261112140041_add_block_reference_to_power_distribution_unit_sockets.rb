# frozen_string_literal: true

class MigrationPowerDistributionSocket < ApplicationRecord
  self.table_name = :power_distribution_unit_sockets

  belongs_to :circuit, optional: true, class_name: "MigrationPowerDistributionCircuit"
  belongs_to :block, optional: true, class_name: "MigrationPowerDistributionBlock"
end

class MigrationPowerDistributionBlock < ApplicationRecord
  self.table_name = :power_distribution_unit_blocks

  belongs_to :record, polymorphic: true
  has_many :sockets, class_name: "MigrationPowerDistributionSocket", foreign_key: :block_id
end

class MigrationPowerDistributionCircuit < ApplicationRecord
  self.table_name = :power_distribution_unit_circuits

  belongs_to :record, polymorphic: true
  has_many :sockets, class_name: "MigrationPowerDistributionSocket", foreign_key: :circuit_id
end

class AddBlockReferenceToPowerDistributionUnitSockets < ActiveRecord::Migration[8.1]
  def change
    add_reference :power_distribution_unit_sockets, :block, null: true, foreign_key: { to_table: :power_distribution_unit_blocks }

    up_only do
      say_with_time "Add block for existing PDU sockets" do
        MigrationPowerDistributionSocket.find_each do |socket|
          block = MigrationPowerDistributionBlock.find_or_create_by!(record_type: socket.circuit.record_type, record_id: socket.circuit.record_id)

          socket.update!(block:)
        end
      end
    end

    change_column_null :power_distribution_unit_sockets, :block_id, false
  end
end
