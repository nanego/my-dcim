# frozen_string_literal: true

class AddDeliveryRelatedAttributesToSite < ActiveRecord::Migration[7.2]
  def change
    change_table :sites, bulk: true do |t|
      t.text :delivery_address
      t.text :delivery_times
    end
  end
end
