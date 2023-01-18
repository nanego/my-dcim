# frozen_string_literal: true

class AddFirstPositionToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :first_position, :integer
  end
end
