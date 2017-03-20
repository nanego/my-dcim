class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.integer :position

      t.timestamps null: false
    end
  end
end
