# frozen_string_literal: true

class MigrationPowerDistributionUnit < ActiveRecord::Base
  self.table_name = :power_distribution_units
end

class AddAttributesToPowerDistributionUnits < ActiveRecord::Migration[8.1]
  def up
    add_column :power_distribution_units, :color, :string
    add_column :power_distribution_units, :grafana_url, :string

    MigrationPowerDistributionUnit.find_each { |p| p.update!(power_line: p.power_line.capitalize) }
  end

  def down
    MigrationPowerDistributionUnit.find_each do |p|
      p.update!(power_line: p.power_line.downcase)
    end

    remove_column :power_distribution_units, :color
    remove_column :power_distribution_units, :grafana_url
  end
end
