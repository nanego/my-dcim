class CreateMoves < ActiveRecord::Migration[5.0]
  def change
    create_table :moves do |t|
      t.references :moveable, polymorphic: true

      t.timestamps
    end
  end
end
