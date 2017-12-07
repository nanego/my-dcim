class IndexForeignKeysInEnclosures < ActiveRecord::Migration
  def change
    add_index :enclosures, :modele_id
  end
end
