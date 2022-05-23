class CreatePduLines < ActiveRecord::Migration[4.2]
  def change
    create_table :pdu_lines do |t|
      t.integer :pdu_id
      t.string :name

      t.timestamps null: false
    end
  end
end
