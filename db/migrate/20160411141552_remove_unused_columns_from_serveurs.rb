class RemoveUnusedColumnsFromServeurs < ActiveRecord::Migration[4.2]
  def change
    remove_column :serveurs, :ilot, :integer
    remove_column :serveurs, :salle_id, :integer
  end
end
