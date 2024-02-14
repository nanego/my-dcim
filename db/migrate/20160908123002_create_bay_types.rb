# frozen_string_literal: true

class MigrationBayType < ActiveRecord::Base
  self.table_name = :bay_types
end

class CreateBayTypes < ActiveRecord::Migration[4.2]
  def change
    create_table :bay_types do |t|
      t.string :name
      t.integer :size
    end

    MigrationBayType.create(name: 'single', size: 1)
    MigrationBayType.create(name: 'double', size: 2)
  end
end
