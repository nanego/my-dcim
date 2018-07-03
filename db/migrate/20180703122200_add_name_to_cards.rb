class AddNameToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :name, :string
  end
end
