# frozen_string_literal: true

class CreateServeurs < ActiveRecord::Migration[4.2]
  def change
    create_table :serveurs do |t|
      t.integer :localisation_id
      t.integer :armoire_id
      t.integer :categorie_id
      t.string :nom
      t.integer :nb_elts
      t.integer :architecture_id
      t.integer :u
      t.integer :marque_id
      t.integer :modele_id
      t.string :numero
      t.integer :conso
      t.boolean :cluster
      t.boolean :critique
      t.integer :domaine_id
      t.integer :gestion_id
      t.integer :acte_id
      t.integer :salle_id
      t.integer :ilot
      t.integer :fc_total
      t.integer :fc_utilise
      t.integer :rj45_total
      t.integer :rj45_utilise
      t.integer :rj45_futur
      t.integer :ipmi_utilise
      t.integer :ipmi_futur
      t.integer :rj45_cm
      t.integer :ipmi_dedie

      t.timestamps null: false
    end
  end
end
