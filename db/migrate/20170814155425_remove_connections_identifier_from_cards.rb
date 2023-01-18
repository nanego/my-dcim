# frozen_string_literal: true

class RemoveConnectionsIdentifierFromCards < ActiveRecord::Migration[5.0]
  def change
    remove_column :cards, :connections_identifier, :string
  end
end
