# frozen_string_literal: true

class AddComposantIdToSlots < ActiveRecord::Migration[4.2]
  def change
    add_column :slots, :composant_id, :integer
    remove_column :slots, :serveur_id, :integer
  end
end
