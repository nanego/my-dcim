# frozen_string_literal: true

class CreateComposants < ActiveRecord::Migration[4.2]
  def change
    create_table :type_composants do |t|
      t.string :title
    end
    create_table :composants do |t|
      t.integer :modele_id
      t.integer :type_composant_id
      t.integer :position
      t.timestamps null: false
    end
    TypeComposant.create!(title: 'ALIM')
    TypeComposant.create!(title: 'IPMI')
    TypeComposant.create!(title: 'CM')
    TypeComposant.create!(title: 'SLOT')
  end
end
