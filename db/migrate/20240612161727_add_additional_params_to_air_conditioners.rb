# frozen_string_literal: true

class AddAdditionalParamsToAirConditioners < ActiveRecord::Migration[7.1]
  def change
    change_table :air_conditioners, bulk: true do |t|
      t.integer :start
      t.integer :range
      t.integer :setpoint
    end
  end
end
