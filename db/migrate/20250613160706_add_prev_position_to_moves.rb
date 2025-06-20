# frozen_string_literal: true

class MigrationMoves < ActiveRecord::Base
  self.table_name = "moves"

  belongs_to :moveable, polymorphic: true
end

class AddPrevPositionToMoves < ActiveRecord::Migration[8.0]
  def change
    add_column :moves, :prev_position, :integer

    up_only do
      say_with_time "Fill prev_position attribute" do
        MigrationMoves.where(executed_at: nil).find_each do |move|
          move.update(prev_position: move.moveable.position)
        end
      end
    end
  end
end
