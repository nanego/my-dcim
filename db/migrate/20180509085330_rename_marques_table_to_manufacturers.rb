class RenameMarquesTableToManufacturers < ActiveRecord::Migration[5.1]
  def change
    rename_table :marques, :manufacturers
    rename_column :modeles, :marque_id, :manufacturer_id
  end
end
