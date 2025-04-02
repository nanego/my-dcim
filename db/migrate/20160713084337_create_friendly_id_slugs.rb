# frozen_string_literal: true

class CreateFriendlyIdSlugs < ActiveRecord::Migration[4.2]
  def change
    create_table :friendly_id_slugs do |t|
      t.string   :slug,           :null => false
      t.integer  :sluggable_id,   :null => false
      t.string   :sluggable_type, :limit => 50
      t.string   :scope
      t.datetime :created_at
    end
    add_index :friendly_id_slugs, :sluggable_id
    add_index :friendly_id_slugs, %i[slug sluggable_type]
    add_index :friendly_id_slugs, %i[slug sluggable_type scope], :unique => true
    add_index :friendly_id_slugs, :sluggable_type

    # Servers table
    add_column :serveurs, :slug, :string
    add_index :serveurs, :slug, unique: true

    # Baies table
    add_column :baies, :slug, :string
    add_index :baies, :slug, unique: true

    # Salles table
    add_column :salles, :slug, :string
    add_index :salles, :slug, unique: true

    # Modeles table
    add_column :modeles, :slug, :string
    add_index :modeles, :slug, unique: true
  end
end
