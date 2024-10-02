# frozen_string_literal: true

class DropPublicActivities < ActiveRecord::Migration[7.1]
  def up
    drop_table :activities
  end

  def down
    create_table :activities, id: :serial do |t|
      t.integer :trackable_id
      t.string :trackable_type
      t.integer :owner_id
      t.string :owner_type
      t.string :key
      t.text :parameters
      t.integer :recipient_id
      t.string :recipient_type

      t.timestamps precision: nil, null: true
    end

    add_index :activities, %i[trackable_id trackable_type]
    add_index :activities, %i[owner_id owner_type]
    add_index :activities, %i[recipient_id recipient_type]
  end
end
