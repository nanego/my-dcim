class IndexForeignKeysInDocuments < ActiveRecord::Migration
  def change
    add_index :documents, :server_id
  end
end
