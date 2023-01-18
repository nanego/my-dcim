# frozen_string_literal: true

class RemoveConsoFromServers < ActiveRecord::Migration[5.2]
  def change
    remove_column :servers, :conso
  end
end
