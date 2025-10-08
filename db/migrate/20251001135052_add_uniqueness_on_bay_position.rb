# frozen_string_literal: true

class AddUniquenessOnBayPosition < ActiveRecord::Migration[8.0]
  def change
    add_index :bays, %i[position islet_id lane], unique: true
  end
end
