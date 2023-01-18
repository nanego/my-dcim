# frozen_string_literal: true

class CreateMaintenanceContracts < ActiveRecord::Migration[4.2]
  def change
    create_table :maintenance_contracts do |t|
      t.date :start_date
      t.date :end_date
      t.integer :maintainer_id
      t.integer :contract_type_id

      t.timestamps null: false
    end
  end
end
