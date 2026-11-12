# frozen_string_literal: true

class MigrationPowerDistributionUnit < ActiveRecord::Base
  self.table_name = :power_distribution_units

  belongs_to :frame, class_name: "MigrationFrame"
end

class AddAttributesToPowerDistributionUnits < ActiveRecord::Migration[8.1]
  def up
    add_column :power_distribution_units, :color, :string

    MigrationPowerDistributionUnit.find_each { |p| p.update!(power_line: p.power_line.capitalize) }
  end

  def down
    MigrationPowerDistributionUnit.find_each do |p|
      power_line = %w[a b].include?(p.power_line.downcase) ? p.power_line.downcase : "a"

      p.update!(power_line:)
    end

    remove_column :power_distribution_units, :color
  end
end
