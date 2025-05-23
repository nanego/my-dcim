# frozen_string_literal: true

# Migration responsible for creating a table with activities
class CreateActivities < ActiveRecord::Migration[4.2]
  # Create table
  def self.up
    create_table :activities do |t|
      t.belongs_to :trackable, :polymorphic => true
      t.belongs_to :owner, :polymorphic => true
      t.string  :key
      t.text    :parameters
      t.belongs_to :recipient, :polymorphic => true

      t.timestamps
    end unless table_exists? 'activities'

    add_index :activities, %i[trackable_id trackable_type] unless index_exists?(:activities, %i[trackable_id trackable_type])
    add_index :activities, %i[owner_id owner_type] unless index_exists?(:activities, %i[owner_id owner_type])
    add_index :activities, %i[recipient_id recipient_type] unless index_exists?(:activities, %i[recipient_id recipient_type])
  end

  # Drop table
  def self.down
    drop_table :activities
  end
end
