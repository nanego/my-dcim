# frozen_string_literal: true

class AddAddressToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :street, :string
    add_column :sites, :city, :string
    add_column :sites, :country, :string
    add_column :sites, :latitude, :decimal
    add_column :sites, :longitude, :decimal
  end
end
