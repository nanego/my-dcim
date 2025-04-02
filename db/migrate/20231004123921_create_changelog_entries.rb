# frozen_string_literal: true

class CreateChangelogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :changelog_entries do |t|
      t.references :object, polymorphic: true, null: false
      t.references :author, polymorphic: true, null: true
      t.string :action, null: false
      t.jsonb :object_changed_attributes, null: false, default: {}
      t.jsonb :metadata, null: false, default: {}

      t.timestamps

      t.index %i[object_type object_id]
      t.index %i[author_type author_id]
    end
  end
end
