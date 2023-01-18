# frozen_string_literal: true

class CreateDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table :documents do |t|
      t.integer :server_id
      t.text :document_data

      t.timestamps
    end
  end
end
