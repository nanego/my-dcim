class IndexForeignKeysInComposants < ActiveRecord::Migration[4.2]
  def change
    add_index :composants, :enclosure_id
  end
end
