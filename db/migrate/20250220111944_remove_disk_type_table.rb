# frozen_string_literal: true

class RemoveDiskTypeTable < ActiveRecord::Migration[8.0]
  def change
    revert do
      create_table :disk_types do |t|
        t.integer :quantity
        t.string :unit
        t.string :technology

        t.timestamps null: false
      end
    end

    up_only do
      ChangelogEntry.where(object_type: "DiskType").find_each(&:destroy!)
    end
  end
end
