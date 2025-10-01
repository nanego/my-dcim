# frozen_string_literal: true

class AddUniquenessOnFramePosition < ActiveRecord::Migration[8.0]
  def change
    add_index :frames, %i[position bay_id], unique: true
  end
end
