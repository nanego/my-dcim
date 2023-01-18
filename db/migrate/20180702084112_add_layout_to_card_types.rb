# frozen_string_literal: true

class AddLayoutToCardTypes < ActiveRecord::Migration[5.1]
  def change
    add_column :card_types, :columns, :integer
    add_column :card_types, :rows, :integer
    add_column :card_types, :orientation, :string
    add_column :card_types, :max_aligned_ports, :integer
  end
end
