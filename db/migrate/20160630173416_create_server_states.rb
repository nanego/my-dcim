# frozen_string_literal: true

class CreateServerStates < ActiveRecord::Migration[4.2]
  def change
    create_table :server_states do |t|
      t.string :title

      t.timestamps null: false
    end
    add_column :serveurs, :server_state_id, :integer
    ServerState.create(title: 'Order In Progress')
  end
end
