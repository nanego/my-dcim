# frozen_string_literal: true

class RemoveBaysCountOnManufacturers < ActiveRecord::Migration[8.0]
  def change
    remove_column :manufacturers, :bays_count, :integer, default: 0, null: false
  end
end
