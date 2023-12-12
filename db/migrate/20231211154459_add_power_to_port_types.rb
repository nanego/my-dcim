class AddPowerToPortTypes < ActiveRecord::Migration[7.0]
  def change
    add_column :port_types, :power, :boolean
  end
end
