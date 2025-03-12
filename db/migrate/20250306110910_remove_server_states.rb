# frozen_string_literal: true

class RemoveServerStates < ActiveRecord::Migration[8.0]
  def change
    revert do
      create_table :server_states do |t|
        t.string :name

        t.timestamps null: false
      end

      change_table :servers, bulk: true do |t|
        t.references :server_state, foreign_key: true, type: :integer
      end
    end

    up_only do
      ChangelogEntry.where(object_type: "ServerState").find_each(&:destroy!)
    end
  end
end
