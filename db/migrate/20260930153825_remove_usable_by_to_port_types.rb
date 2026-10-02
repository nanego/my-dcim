# frozen_string_literal: true

class PortTypeMigration < ApplicationRecord
  self.table_name = :port_types
end

class RemoveUsableByToPortTypes < ActiveRecord::Migration[8.1]
  def change
    revert do
      create_enum :port_types_usable_by, %w[pdu server]
      add_column :port_types, :usable_by, :enum, enum_type: :port_types_usable_by, array: true

      change_table :port_types, bulk: true do |t|
        t.change_default :usable_by, from: nil, to: []
        t.change_null :usable_by, false
      end
    end
  end
end
