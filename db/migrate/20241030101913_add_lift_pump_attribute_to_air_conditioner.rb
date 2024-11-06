# frozen_string_literal: true

class AddLiftPumpAttributeToAirConditioner < ActiveRecord::Migration[7.2]
  def change
    add_column :air_conditioners, :lift_pump, :boolean, null: false, default: false
  end
end
