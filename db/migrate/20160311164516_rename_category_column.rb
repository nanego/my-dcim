# frozen_string_literal: true

class MigrationCategory < ActiveRecord::Base
  self.table_name = :categories
end

class RenameCategoryColumn < ActiveRecord::Migration[4.2]
  def change
    rename_column :modeles, :categorie_id, :category_id
  end

  MigrationCategory.find_or_create_by!(title: "Blank Panel", published: true)
  MigrationCategory.find_or_create_by!(title: "Patch Panel", published: true)
end
