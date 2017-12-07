class IndexForeignKeysInColors < ActiveRecord::Migration
  def change
    add_index :colors, :parent_id
  end
end
