# frozen_string_literal: true

class MigrationEnclosure < ActiveRecord::Base
  self.table_name = :enclosures
end

class UpdateEnclosureDisplay < ActiveRecord::Migration[8.0]
  def change
    change_column_default :enclosures, :display, from: nil, to: "vertical"

    up_only do
      MigrationEnclosure.reset_column_information
      MigrationEnclosure.find_each do |enclosure|
        enclosure.update!(display: "vertical") if enclosure.display.blank?
      end
    end

    change_column_null :enclosures, :display, false
  end
end
