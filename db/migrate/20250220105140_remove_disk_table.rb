# frozen_string_literal: true

class RemoveDiskTable < ActiveRecord::Migration[8.0]
  def change
    revert do
      create_table :disks do |t|
        t.integer :server_id, null: false
        t.integer :disk_type_id, null: false
        t.integer :quantity

        t.timestamps null: false

        t.index :disk_type_id
        t.index :server_id

        t.references :disk_types, foreign_key: true, null: false, type: :integer
      end
    end

    up_only do
       ChangelogEntry.where(object_type: "Disk").find_each(&:destroy!)
    end
  end
end
