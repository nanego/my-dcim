class CreateLocalisations < ActiveRecord::Migration[4.2]
  def change
    create_table :localisations do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
  end
end
