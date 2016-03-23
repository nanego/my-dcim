class CreateColors < ActiveRecord::Migration
  def change
    create_table :colors do |t|
      t.string :parent_type
      t.string :parent_id
      t.string :code

      t.timestamps null: false
    end
  end
end
