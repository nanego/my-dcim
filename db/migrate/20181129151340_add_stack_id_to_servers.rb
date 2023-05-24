# frozen_string_literal: true

class AddStackIdToServers < ActiveRecord::Migration[5.1]
  def change
    add_column :servers, :stack_id, :integer
  end
end
