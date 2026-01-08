# frozen_string_literal: true

class AddMissingForeignKeysToServers < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :servers, :frames
    add_foreign_key :servers, :domaines
  end
end
