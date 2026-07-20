# frozen_string_literal: true

class AddPowerLineToPowerDistributionUnits < ActiveRecord::Migration[8.1]
  def change
    add_column :power_distribution_units, :power_line, :string, null: false, default: "a"
    update_view :search_results, version: 4, revert_to_version: 3

    reversible do |dir|
      dir.up { remove_column :power_distribution_units, :name }
      dir.down do
        add_column :power_distribution_units, :name, :string

        PowerDistributionUnit.find_each do |p|
          p.name = "#{p.frame.name}-#{p.power_line}"
          p.save!
        end

        change_column_null :power_distribution_units, :name, false
      end
    end
  end
end
