class CreateSlots < ActiveRecord::Migration[4.2]
  def change
    create_table :slots do |t|
      t.integer :numero
      t.integer :serveur_id
      t.string :valeur

      t.timestamps null: false
    end
  end
end
