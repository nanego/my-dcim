class CreatePdus < ActiveRecord::Migration
  def change
    create_table :pdus do |t|
      t.integer :frame_id
      t.string :name

      t.timestamps null: false
    end
  end
end
