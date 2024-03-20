# frozen_string_literal: true

class MigrationServer < ApplicationRecord
  self.table_name = "servers"
end

class MigrationNetwork
  TYPES = %w[gbe 10gbe fiber].freeze
end

class UpdateNetworkAttribute < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :network_types, :string, array: true, default: []

    reversible do |direction|
      direction.up do
        MigrationServer.find_each do |s|
          s.network_types = [MigrationNetwork::TYPES[s.network_id]] if s.network_id.present?
          s.save!
        end
      end

      direction.down do
        MigrationServer.find_each do |s|
          s.network_id = MigrationNetwork::TYPES.index(s.network_types.first) if s.network_types.present?
          s.save!
        end
      end
    end

    remove_column :servers, :network_id, :integer

    add_column :modeles, :network_types, :string, array: true, default: []
  end
end
