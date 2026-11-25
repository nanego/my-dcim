# frozen_string_literal: true

class MigrationSocket < ActiveRecord::Base
  self.table_name = "power_distribution_unit_sockets"

  belongs_to :block, class_name: "MigrationBlock"
end

class MigrationBlock < ActiveRecord::Base
  self.table_name = "power_distribution_unit_blocks"

  has_many :sockets, -> { order(:position) }, class_name: "MigrationSocket", inverse_of: :block
end

class RenameNumberAndAddNameToSocket < ActiveRecord::Migration[8.1]
  def change
    change_table :power_distribution_unit_sockets, bulk: true do |t|
      t.rename :number, :position
      t.string :name
    end

    up_only do
      MigrationBlock.find_each do |block|
        block.sockets.each.with_index(1) do |socket, index|
          socket.update!(name: socket.position, position: index)
        end
      end
    end

    change_column_null :power_distribution_unit_sockets, :name, false
  end
end
