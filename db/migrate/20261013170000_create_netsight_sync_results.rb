# frozen_string_literal: true

class CreateNetsightSyncResults < ActiveRecord::Migration[8.1]
  def change
    create_table :netsight_sync_results do |t|
      t.references :external_app_request, null: false, foreign_key: { on_delete: :cascade }
      t.references :server, null: false, type: :integer, foreign_key: { on_delete: :cascade }
      t.references :port, type: :integer, foreign_key: { on_delete: :cascade }
      t.string :kind, null: false
      t.string :status, null: false
      t.string :if_name
      t.string :dcim_value
      t.string :netsight_value
      t.string :netsight_peer
      t.string :dcim_path
      t.datetime :applied_at

      t.timestamps
    end

    add_index :netsight_sync_results, %i[kind status]
  end
end
