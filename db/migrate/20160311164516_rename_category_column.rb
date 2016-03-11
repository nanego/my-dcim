class RenameCategoryColumn < ActiveRecord::Migration
  def change
    rename_column :modeles, :categorie_id, :category_id
  end
end
