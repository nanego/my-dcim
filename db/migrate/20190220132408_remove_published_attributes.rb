class RemovePublishedAttributes < ActiveRecord::Migration[5.2]
  def change
    remove_column :architectures, :published
    remove_column :categories, :published
    remove_column :domaines, :published
    remove_column :gestions, :published
    remove_column :manufacturers, :published
    remove_column :modeles, :published
    remove_column :rooms, :published
  end
end
