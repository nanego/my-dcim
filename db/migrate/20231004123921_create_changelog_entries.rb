class CreateChangelogEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :changelog_entries do |t|
      t.references :object, polymorphic: true
      t.references :author, polymorphic: true
      t.string :action
      t.jsonb :object_changes
      t.jsonb :metadata

      t.timestamps

      t.index %i[object_type object_id]
      t.index %i[author_type author_id]
    end
  end
end
