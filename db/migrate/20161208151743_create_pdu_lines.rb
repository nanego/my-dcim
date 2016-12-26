class CreatePduLines < ActiveRecord::Migration
  def change
    create_table :pdu_lines do |t|
      t.integer :pdu_id
      t.string :name

      t.timestamps null: false
    end
  end
end
