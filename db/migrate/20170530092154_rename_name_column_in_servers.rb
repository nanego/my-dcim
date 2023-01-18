# frozen_string_literal: true

class RenameNameColumnInServers < ActiveRecord::Migration[5.0]
  def change
    rename_column :servers, :nom, :name
  end
end
