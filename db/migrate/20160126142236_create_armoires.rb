class CreateArmoires < ActiveRecord::Migration[4.2]
  def change
    create_table :armoires do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
  end
end
