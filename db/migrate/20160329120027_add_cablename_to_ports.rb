class AddCablenameToPorts < ActiveRecord::Migration
  def change
    add_column :ports, :cablename, :string
  end
end
