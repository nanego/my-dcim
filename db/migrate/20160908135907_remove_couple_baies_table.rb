class RemoveCoupleBaiesTable < ActiveRecord::Migration
  def change
    drop_table :couple_baies
  end
end
