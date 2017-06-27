class RemovePolymorphicAssociationOnPorts < ActiveRecord::Migration[5.0]
  def change
    rename_column :ports, :parent_id, :cards_server_id
    remove_column :ports, :parent_type
  end
end
