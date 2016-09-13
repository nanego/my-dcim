class RemoveCoupleBaiesTable < ActiveRecord::Migration
  def up
    drop_table :couple_baies if table_exists? :couple_baies
  end
end
