class CreateAirConditionerModels < ActiveRecord::Migration[7.1]
  def change
    create_table :air_conditioner_models do |t|
      t.string :name
      t.references :manufacturer, null: false, foreign_key: true

      t.timestamps
    end
    AirConditionerModel.create(name: 'Standard Model', manufacturer: Manufacturer.first)
  end
end
