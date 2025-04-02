# frozen_string_literal: true

class RemoveDiskTable < ActiveRecord::Migration[8.0]
  def change
    revert do
      create_table :disks do |t|
        t.references :server, null: false, type: :integer
        t.references :disk_type, foreign_key: true, null: false, type: :integer

        t.integer :quantity

        t.timestamps
      end
    end

    up_only do
      ChangelogEntry.where(object_type: "Disk").find_each(&:destroy!)
    end
  end
end
