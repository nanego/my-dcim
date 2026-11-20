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

class AddPositionToPdu < ActiveRecord::Migration[8.1]
  def change
    add_column :power_distribution_units, :position, :integer

    up_only do
      MigrationFrame.with_pdus.find_each do |frame|
        frame.power_distribution_units.order(:created_at).each.with_index(1) do |pdu, i|
          pdu.update_column :position, i
        end
      end
    end
  end
end
