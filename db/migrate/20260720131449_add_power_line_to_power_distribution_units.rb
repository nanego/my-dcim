# frozen_string_literal: true

class MigrationFrame < ActiveRecord::Base
  self.table_name = :frames

  has_many :power_distribution_units, class_name: "MigrationPowerDistributionUnit", foreign_key: :frame_id

  scope :with_pdus, -> { joins(:power_distribution_units).includes(:power_distribution_units).distinct }
end

class MigrationPowerDistributionUnit < ActiveRecord::Base
  self.table_name = :power_distribution_units

  belongs_to :frame, class_name: "MigrationFrame"
end

class AddPowerLineToPowerDistributionUnits < ActiveRecord::Migration[8.1]
  def up
    add_column :power_distribution_units, :power_line, :string

    MigrationFrame.reset_column_information
    MigrationFrame.with_pdus.find_each do |frame|
      raise "More than 2 pdu for frame with id=#{frame.id}" if frame.power_distribution_units.count > 2

      frame.power_distribution_units.each_with_index do |pdu, i|
        pdu.power_line = i.even? ? "a" : "b"
        pdu.save!
      end
    end

    change_column_null :power_distribution_units, :power_line, false
    add_index :power_distribution_units, %i[frame_id power_line], unique: true

    update_view :search_results, version: 4
    remove_column :power_distribution_units, :name
  end

  def down
    add_column :power_distribution_units, :name, :string

    MigrationPowerDistributionUnit.reset_column_information
    MigrationPowerDistributionUnit.find_each do |p|
      p.name = "#{p.frame.name}-#{p.power_line.upcase}"
      p.save!
    end

    change_column_null :power_distribution_units, :name, false
    update_view :search_results, version: 3

    remove_index :power_distribution_units, %i[frame_id power_line]
    remove_column :power_distribution_units, :power_line
  end
end
