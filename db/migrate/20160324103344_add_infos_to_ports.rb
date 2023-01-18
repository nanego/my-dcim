# frozen_string_literal: true

class AddInfosToPorts < ActiveRecord::Migration[4.2]
  def change
    add_column :ports, :vlans, :string
    add_column :ports, :color, :string
  end
end
