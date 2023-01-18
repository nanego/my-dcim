# frozen_string_literal: true

class AddPositionToIslets < ActiveRecord::Migration[5.1]
  def change
    add_column :islets, :position, :integer
  end
end
