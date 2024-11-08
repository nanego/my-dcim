# frozen_string_literal: true

class AddWidthAttributeToFrames < ActiveRecord::Migration[7.2]
  def change
    add_column :frames, :width, :float
  end
end
