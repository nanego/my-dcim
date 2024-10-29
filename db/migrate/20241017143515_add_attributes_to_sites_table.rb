# frozen_string_literal: true

class AddAttributesToSitesTable < ActiveRecord::Migration[7.2]
  def change
    change_table :sites, bulk: true do |t|
      t.text :description
    end
  end
end
