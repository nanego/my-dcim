# frozen_string_literal: true

class MigrationPowerDistributionUnit < ActiveRecord::Base
  self.table_name = :power_distribution_units
end

class AddAttributesToPowerDistributionUnits < ActiveRecord::Migration[8.1]
  def up
    change_table :power_distribution_units, bulk: true do |t|
      t.string :color
      t.string :grafana_url
    end

    MigrationPowerDistributionUnit.find_each { |p| p.update!(power_line: p.power_line.capitalize) }
  end

  def down
    MigrationPowerDistributionUnit.find_each do |p|
      p.update!(power_line: p.power_line.downcase)
    end

    change_table :power_distribution_units, bulk: true do |t|
      t.remove :color, :grafana_url
    end
  end
end
