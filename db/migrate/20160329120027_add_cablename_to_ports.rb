class AddCablenameToPorts < ActiveRecord::Migration[4.2]
  def change
    add_column :ports, :cablename, :string
  end
end
