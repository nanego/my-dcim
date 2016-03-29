class AddNameToComposants < ActiveRecord::Migration
  def change
    add_column :composants, :name, :string
  end
end
