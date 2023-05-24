# frozen_string_literal: true

class AddPositionToSalles < ActiveRecord::Migration[4.2]
  def change
    add_column :salles, :position, :integer
  end
end
