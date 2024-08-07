# frozen_string_literal: true

class CreateExternalAppRecords < ActiveRecord::Migration[7.1]
  def change
    create_table :external_app_records do |t|
      t.references :server, null: false, foreign_key: true
      t.string :app_name
      t.string :external_name
      t.string :external_id
      t.string :external_serial

      t.timestamps
    end
  end
end
