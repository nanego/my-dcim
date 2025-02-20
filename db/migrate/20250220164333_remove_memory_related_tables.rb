# frozen_string_literal: true

class RemoveMemoryRelatedTables < ActiveRecord::Migration[8.0]
  def change
    revert do
      create_table :memory_types do |t|
        t.integer :quantity
        t.string :unit

        t.timestamps null: false
      end

      create_table :memory_components do |t|
        t.integer :server_id
        t.integer :memory_type_id, null: false
        t.integer :quantity

        t.index :memory_type_id

        t.references :memory_types, foreign_key: true, null: false, type: :integer

        t.timestamps null: false
      end
    end

    up_only do
      ChangelogEntry.where(object_type: %w[MemoryComponent MemoryType]).find_each(&:destroy!)
    end
  end
end
