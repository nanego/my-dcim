# frozen_string_literal: true

class AddGridAreasToEnclosures < ActiveRecord::Migration[5.2]
  def change
    add_column :enclosures, :grid_areas, :text
  end
end
