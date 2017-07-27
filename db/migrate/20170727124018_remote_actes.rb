class RemoteActes < ActiveRecord::Migration[5.0]
  def change
    drop_table :actes
    remove_column :servers, :acte_id
  end
end
