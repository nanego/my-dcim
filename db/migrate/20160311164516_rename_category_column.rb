# frozen_string_literal: true

class RenameCategoryColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :modeles, :categorie_id, :category_id
  end
  Category.find_or_create_by!(title: 'Blank Panel', published: true)
  Category.find_or_create_by!(title: 'Patch Panel', published: true)
end
