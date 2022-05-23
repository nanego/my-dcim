class AddNameToComposants < ActiveRecord::Migration[4.2]
  def change
    add_column :composants, :name, :string
  end
end
