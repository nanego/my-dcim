# frozen_string_literal: true

class AddColorToModeles < ActiveRecord::Migration[4.2]
  def change
    add_column :modeles, :color, :string
  end
end
