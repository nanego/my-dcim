# frozen_string_literal: true

class RenamePduSocketName < ActiveRecord::Migration[8.1]
  def change
    rename_column :power_distribution_unit_sockets, :name, :number

    reversible do |direction|
      change_table :power_distribution_unit_sockets do |t|
        direction.up   { t.change :number, "integer USING CAST(number AS integer)" }
        direction.down { t.change :number, :string }
      end
    end
  end
end
