# frozen_string_literal: true

class AddMinSetpointToAirConditioners < ActiveRecord::Migration[7.1]
  def change
    add_column :air_conditioners, :min_setpoint, :integer
  end
end
