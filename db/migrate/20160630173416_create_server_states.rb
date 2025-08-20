# frozen_string_literal: true

class MigrationServerState < ActiveRecord::Base
  self.table_name = :server_states
end

class CreateServerStates < ActiveRecord::Migration[4.2]
  def change
    create_table :server_states do |t|
      t.string :title

      t.timestamps null: false
    end

    add_column :serveurs, :server_state_id, :integer

    MigrationServerState.create(title: "Order In Progress")
  end
end
