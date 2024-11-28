# frozen_string_literal: true

class DropMaintainceRelatedTables < ActiveRecord::Migration[7.2]
  def change
    revert do
      create_table :contract_types, id: :serial do |t|
        t.string "name"

        t.datetime "created_at", precision: nil, null: false
        t.datetime "updated_at", precision: nil, null: false
      end

      create_table :maintainers, id: :serial do |t|
        t.string "name"

        t.datetime "created_at", precision: nil, null: false
        t.datetime "updated_at", precision: nil, null: false
      end

      create_table :maintenance_contracts, id: :serial do |t|
        t.date :start_date
        t.date :end_date
        t.references :maintainer, foreign_key: true, null: false, type: :integer
        t.references :contract_type, foreign_key: true, null: false, type: :integer

        t.datetime "created_at", precision: nil, null: false
        t.datetime "updated_at", precision: nil, null: false

        t.references :server, foreign_key: true, null: false, type: :integer
      end
    end

    up_only do
      ChangelogEntry.where(object_type: %w[ContractType Maintainer MaintenanceType]).find_each(&:destroy!)
    end
  end
end
