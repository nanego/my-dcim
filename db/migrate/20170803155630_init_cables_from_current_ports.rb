# frozen_string_literal: true

class InitCablesFromCurrentPorts < ActiveRecord::Migration[5.0]
  def up
    Port.all.each do |port|
      cable = Cable.create(name: port.cablename, color: port.color)
      Connection.create(port: port, cable: cable)
    end
  end

  def down; end
end
