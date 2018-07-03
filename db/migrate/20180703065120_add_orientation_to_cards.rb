class AddOrientationToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :orientation, :string
    add_column :card_types, :first_position, :integer
    remove_column :card_types, :orientation, :string
  end
end
