# frozen_string_literal: true

class AddCounterCacheToCables < ActiveRecord::Migration[7.1]
  def change
    add_column :cables, :connections_count, :integer, null: false, default: 0

    up_only do
      say_with_time "Populate counters" do
        Cable.find_each { |cable| Cable.reset_counters(cable.id, :connections) }
      end
    end
  end
end
