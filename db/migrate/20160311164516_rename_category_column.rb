class RenameCategoryColumn < ActiveRecord::Migration
  def change
    rename_column :modeles, :categorie_id, :category_id
  end
  Category.find_or_create_by!(title: 'Blank Panel', published: true)
  Category.find_or_create_by!(title: 'Patch Panel', published: true)
end
