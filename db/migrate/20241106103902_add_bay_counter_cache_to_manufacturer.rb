# frozen_string_literal: true

class AddBayCounterCacheToManufacturer < ActiveRecord::Migration[7.2]
  def change
    add_column :manufacturers, :bays_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate counters" do
        Manufacturer.find_each do |manufacturer|
          Manufacturer.reset_counters(manufacturer.id, :bays)
        end
      end
    end
  end
end
