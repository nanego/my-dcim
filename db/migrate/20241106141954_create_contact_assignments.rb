# frozen_string_literal: true

class CreateContactAssignments < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_assignments do |t|
      t.belongs_to :site, null: false, foreign_key: true
      t.belongs_to :contact, null: false, foreign_key: true
      t.belongs_to :contact_role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
