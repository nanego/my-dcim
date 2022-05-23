class RemoveCoupleBaiesTable < ActiveRecord::Migration[4.2]
  def up
    drop_table :couple_baies if table_exists? :couple_baies
  end
end
