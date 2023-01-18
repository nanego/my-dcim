# frozen_string_literal: true

class CreateStacks < ActiveRecord::Migration[5.2]
  def up
    create_table :stacks do |t|
      t.string :name
      t.string :color

      t.timestamps null: false
    end
    Stack.create(name: "Rouge", color: "ee3b3b")
    Stack.create(name: "Vert", color: "008000")
  end

  def down
    drop_table :stacks
  end
end
