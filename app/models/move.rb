# frozen_string_literal: true

class Move < ApplicationRecord
  has_changelog

  belongs_to :moveable, polymorphic: true
  belongs_to :frame
  belongs_to :prev_frame, class_name: "Frame"

  attr_accessor :remove_connections

  def clear_connections
    server = moveable
    # Delete current moved connections
    MovedConnection.per_servers([server]).delete_all
    # Add moved connection for each port
    server.ports.each do |p|
      MovedConnection.create({ port_from_id: p.id,
                               vlans: "",
                               color: "",
                               cablename: "" })
    end
  end

  def execute_movement(apply_connections: true)
    equipment = moveable
    equipment.frame = frame
    equipment.position = position
    if equipment.save
      if apply_connections
        MovedConnection.per_servers([equipment]).map(&:execute_movement)
      end
      delete
    end
  end
end
