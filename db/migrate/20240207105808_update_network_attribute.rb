# frozen_string_literal: true

class MigrationServer < ActiveRecord::Base
  self.table_name = "servers"
end

class MigrationNetwork
  TYPES = %w[gbe 10gbe fiber].freeze
end

class UpdateNetworkAttribute < ActiveRecord::Migration[7.0]
  def change
    add_column :servers, :network_types, :string, array: true, default: []

    say_with_time "update existing servers" do
      reversible do |direction|
        direction.up do
          MigrationServer.find_each do |s|
            s.network_types = [MigrationNetwork::TYPES[s.network_id - 1]] if s.network_id.present?
            s.save!
          end
        end

        direction.down do
          MigrationServer.find_each do |s|
            s.network_id = MigrationNetwork::TYPES.index(s.network_types.first) + 1 if s.network_types.present?
            s.save!
          end
        end
      end
    end

    remove_column :servers, :network_id, :integer

    add_column :modeles, :network_types, :string, array: true, default: []
  end
end
