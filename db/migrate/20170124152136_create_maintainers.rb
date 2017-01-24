class CreateMaintainers < ActiveRecord::Migration
  def change
    create_table :maintainers do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
