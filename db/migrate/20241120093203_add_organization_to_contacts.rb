# frozen_string_literal: true

class AddOrganizationToContacts < ActiveRecord::Migration[7.2]
  def change
    add_column :contacts, :organization, :string
  end
end
