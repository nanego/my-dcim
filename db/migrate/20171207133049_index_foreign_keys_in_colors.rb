class IndexForeignKeysInColors < ActiveRecord::Migration[4.2]
  def change
    add_index :colors, :parent_id
  end
end
