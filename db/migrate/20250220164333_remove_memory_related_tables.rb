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
        t.references :server, null: false, type: :integer
        t.references :memory_type, foreign_key: true, null: false, type: :integer

        t.integer :quantity

        t.timestamps null: false
      end
    end

    up_only do
      ChangelogEntry.where(object_type: %w[MemoryComponent MemoryType]).find_each(&:destroy!)
    end
  end
end
