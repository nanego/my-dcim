# frozen_string_literal: true

class IndexForeignKeysInDocuments < ActiveRecord::Migration[4.2]
  def change
    add_index :documents, :server_id
  end
end
