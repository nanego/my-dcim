class AddDisplayToEnclosures < ActiveRecord::Migration[5.0]
  def change
    add_column :enclosures, :display, :string
  end
end
