# frozen_string_literal: true

class MigrationStack < ActiveRecord::Base
  self.table_name = :stacks
end

class CreateStacks < ActiveRecord::Migration[5.2]
  def up
    create_table :stacks do |t|
      t.string :name
      t.string :color

      t.timestamps null: false
    end

    MigrationStack.create(name: "Rouge", color: "ee3b3b")
    MigrationStack.create(name: "Vert", color: "008000")
  end

  def down
    drop_table :stacks
  end
end
