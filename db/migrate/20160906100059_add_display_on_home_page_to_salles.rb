class AddDisplayOnHomePageToSalles < ActiveRecord::Migration
  def change
    add_column :salles, :display_on_home_page, :boolean
  end
end
