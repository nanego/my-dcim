# frozen_string_literal: true

class MigrationTypeComposant < ActiveRecord::Base
  self.table_name = :type_composants
end

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
    MigrationTypeComposant.create!(title: 'ALIM')
    MigrationTypeComposant.create!(title: 'IPMI')
    MigrationTypeComposant.create!(title: 'CM')
    MigrationTypeComposant.create!(title: 'SLOT')
  end
end
