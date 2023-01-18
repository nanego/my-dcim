# frozen_string_literal: true

class AddPortColorToServers < ActiveRecord::Migration[5.0]
  def change
    add_column :servers, :port_color, :string
  end
end
