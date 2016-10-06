class RemoveArmoiresTable < ActiveRecord::Migration
  def up
    drop_table :armoires
    remove_column :servers, :armoire_id
  end
  def down
    create_table :armoires do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
    add_column :servers, :armoire_id, :integer
  end
end
