class RemoveClusterColumnFromServeurs < ActiveRecord::Migration
  def change
    remove_column :serveurs, :cluster, :boolean
  end
end
