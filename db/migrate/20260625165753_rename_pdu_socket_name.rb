# frozen_string_literal: true

class SocketMigration < ActiveRecord::Base
  self.table_name = "power_distribution_unit_sockets"
end

class RenamePduSocketName < ActiveRecord::Migration[8.1]
  def change
    rename_column :power_distribution_unit_sockets, :name, :number

    reversible do |direction|
      change_table :power_distribution_unit_sockets do |t|
        direction.up do
          SocketMigration.find_each do |socket|
            socket.update_columns(number: socket.number.gsub(/\D*/, ""))
          end

          t.change :number, "integer USING CAST(number AS integer)"
        end
        direction.down { t.change :number, :string }
      end
    end
  end
end
