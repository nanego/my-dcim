class AddDisplayOnHomePageToSalles < ActiveRecord::Migration[4.2]
  def change
    add_column :salles, :display_on_home_page, :boolean
  end
end
