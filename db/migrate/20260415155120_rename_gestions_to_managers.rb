# frozen_string_literal: true

class RenameGestionsToManagers < ActiveRecord::Migration[8.0]
  def change
    rename_table :gestions, :managers
    rename_column :servers, :gestion_id, :manager_id
  end
end
