class RemovePhaseFromServeurs < ActiveRecord::Migration
  def change
    remove_column :serveurs, :phase, :integer
  end
end
