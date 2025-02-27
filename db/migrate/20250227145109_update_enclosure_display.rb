# frozen_string_literal: true

class MigrationEnclosure < ActiveRecord::Base
  self.table_name = :enclosures
end

class UpdateEnclosureDisplay < ActiveRecord::Migration[8.0]
  def up
    add_column :enclosures, :tmp_display, :integer, default: 0, null: false

    MigrationEnclosure.reset_column_information
    MigrationEnclosure.find_each do |enclosure|
      display = case enclosure.display
                when "horizontal"
                  1
                when "grid"
                  2
                else
                  0
                end

      enclosure.update!(tmp_display: display)
    end

    change_table :enclosures do |t|
      t.remove :display
      t.rename :tmp_display, :display
    end
  end

  def down
    add_column :enclosures, :tmp_display, :string

    MigrationEnclosure.reset_column_information
    MigrationEnclosure.find_each do |enclosure|
      display = case enclosure.display
                when 1
                  "horizontal"
                when 2
                  "grid"
                else
                  "vertical"
                end

      enclosure.update!(tmp_display: display)
    end

    change_table :enclosures do |t|
      t.remove :display
      t.rename :tmp_display, :display
    end
  end
end
