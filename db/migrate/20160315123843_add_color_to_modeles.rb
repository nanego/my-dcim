class AddColorToModeles < ActiveRecord::Migration
  def change
    add_column :modeles, :color, :string
  end
end
