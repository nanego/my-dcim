# frozen_string_literal: true

class RemoveSlotsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :slots
  end
end
