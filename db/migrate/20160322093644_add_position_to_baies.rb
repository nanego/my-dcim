# frozen_string_literal: true

class AddPositionToBaies < ActiveRecord::Migration[4.2]
  def change
    add_column :baies, :position, :integer
  end
end
