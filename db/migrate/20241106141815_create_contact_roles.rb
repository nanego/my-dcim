# frozen_string_literal: true

class CreateContactRoles < ActiveRecord::Migration[7.2]
  def change
    create_table :contact_roles do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
