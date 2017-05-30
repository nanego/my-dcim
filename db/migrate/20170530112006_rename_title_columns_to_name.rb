class RenameTitleColumnsToName < ActiveRecord::Migration[5.0]
  def change
    rename_column :actes, :title, :name
    rename_column :architectures, :title, :name
    rename_column :categories, :title, :name
    rename_column :clusters, :title, :name
    rename_column :domaines, :title, :name
    rename_column :frames, :title, :name
    rename_column :gestions, :title, :name
    rename_column :marques, :title, :name
    rename_column :modeles, :title, :name
    rename_column :rooms, :title, :name
    rename_column :server_states, :title, :name
    rename_column :type_composants, :title, :name
  end
end
