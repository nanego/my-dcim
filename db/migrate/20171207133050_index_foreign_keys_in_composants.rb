class IndexForeignKeysInComposants < ActiveRecord::Migration
  def change
    add_index :composants, :enclosure_id
  end
end
