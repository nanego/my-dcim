class CreateArchitectures < ActiveRecord::Migration
  def change
    create_table :architectures do |t|
      t.string :title
      t.text :description
      t.boolean :published

      t.timestamps null: false
    end
  end
end
