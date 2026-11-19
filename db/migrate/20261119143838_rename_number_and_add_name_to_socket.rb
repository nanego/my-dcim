# frozen_string_literal: true

class SocketMigration < ActiveRecord::Base
  self.table_name = "power_distribution_unit_sockets"
end

class RenameNumberAndAddNameToSocket < ActiveRecord::Migration[8.1]
  def change
    change_table :power_distribution_unit_sockets, bulk: true do |t|
      t.rename :number, :position
      t.string :name
    end

    up_only do
      SocketMigration.find_each { |s| s.update!(name: s.position) }
    end

    change_column_null :power_distribution_unit_sockets, :name, false
  end
end
