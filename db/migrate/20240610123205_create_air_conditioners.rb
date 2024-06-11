class CreateAirConditioners < ActiveRecord::Migration[7.1]
  def change
    create_table :air_conditioners do |t|
      t.string :name
      t.string :status
      t.date :last_service
      t.references :air_conditioner_model, null: false, foreign_key: true
      t.references :bay, null: false, foreign_key: true
      t.string :position

      t.timestamps
    end
  end
end
