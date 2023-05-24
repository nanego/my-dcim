# frozen_string_literal: true

class RemovePortColorFromServers < ActiveRecord::Migration[5.0]
  def change
    remove_column :servers, :port_color, :string
  end
end
