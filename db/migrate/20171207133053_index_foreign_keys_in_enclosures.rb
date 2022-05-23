class IndexForeignKeysInEnclosures < ActiveRecord::Migration[4.2]
  def change
    add_index :enclosures, :modele_id
  end
end
