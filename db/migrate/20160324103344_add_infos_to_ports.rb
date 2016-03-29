class AddInfosToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :vlans, :string
    add_column :ports, :color, :string
  end
end
