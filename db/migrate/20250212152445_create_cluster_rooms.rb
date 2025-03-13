# frozen_string_literal: true

class CreateClusterRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :cluster_rooms do |t|
      t.references :cluster, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
