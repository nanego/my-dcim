class CreateSlots < ActiveRecord::Migration
  def change
    create_table :slots do |t|
      t.integer :numero
      t.integer :serveur_id
      t.string :valeur

      t.timestamps null: false
    end
  end
end
