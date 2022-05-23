class AddParametersToModeles < ActiveRecord::Migration[4.2]
  def change
    add_column :modeles, :categorie_id, :integer
    add_column :modeles, :nb_elts, :integer
    add_column :modeles, :architecture_id, :integer
    add_column :modeles, :u, :integer
    add_column :modeles, :marque_id, :integer

    remove_column :serveurs, :categorie_id, :integer
    remove_column :serveurs, :nb_elts, :integer
    remove_column :serveurs, :architecture_id, :integer
    remove_column :serveurs, :u, :integer
    remove_column :serveurs, :marque_id, :integer
  end
end
