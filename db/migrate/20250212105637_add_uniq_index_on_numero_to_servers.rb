# frozen_string_literal: true

class MigrationServer < ActiveRecord::Base
  self.table_name = :servers
end

class AddUniqIndexOnNumeroToServers < ActiveRecord::Migration[8.0]
  def change
    up_only do
      MigrationServer.where(numero: "").update_all(numero: nil)
    end

    add_index :servers, :numero, unique: true
  end
end
