# frozen_string_literal: true

class PowerDistributionUnitMigration < ActiveRecord::Base
  self.table_name = "power_distribution_units"

  belongs_to :bay, optional: true
  belongs_to :frame, optional: true

  enum :side, { left: 0, right: 1 }
end

class BayMigration < ActiveRecord::Base
  self.table_name = "bays"

  has_many :frames
end

class FrameMigration < ActiveRecord::Base
  self.table_name = "frames"
end

class AddFrameAndRemoveBayFromToPowerDistributionUnit < ActiveRecord::Migration[8.1]
  def up
    add_reference :power_distribution_units, :frame, foreign_key: true, null: true
    PowerDistributionUnitMigration.reset_column_information

    PowerDistributionUnitMigration.includes(:bay).find_each do |record|
      record.update_column(
        :frame_id,
        record.left? ? record.bay.frames.first.id : record.bay.frames.last.id,
      )
    end

    remove_reference :power_distribution_units, :bay
    change_column_null :power_distribution_units, :frame_id, false
  end

  def down
    add_reference :power_distribution_units, :bay_id, foreign_key: true, null: true
    PowerDistributionUnitMigration.reset_column_information

    PowerDistributionUnitMigration.includes(:frame).find_each do |record|
      record.update_column(:bay_id, record.frame.bay_id)
    end

    remove_reference :power_distribution_units, :frame
    change_column_null :power_distribution_units, :bay_id, false
  end
end
