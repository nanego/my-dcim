class CreateBays < ActiveRecord::Migration
  def change
    create_table :bays do |t|
      t.string :name
      t.integer :lane
      t.integer :position
      t.integer :bay_type_id
      t.integer :islet_id

      t.timestamps null: false
    end
    add_column :frames, :bay_id, :integer
  end
end
