# frozen_string_literal: true

class Move < ApplicationRecord
  belongs_to :moveable, polymorphic: true

  belongs_to :frame
  belongs_to :prev_frame, class_name: 'Frame', foreign_key: :prev_frame_id

  # TODO: check if validates_presence_of is really required
  # validates_presence_of :frame, :moveable

  attr_accessor :remove_connections

  def clear_connections
    server = self.moveable
    # Delete current moved connections
    MovedConnection.per_servers([server]).delete_all
    # Add moved connection for each port
    server.ports.each do |p|
      MovedConnection.create({port_from_id: p.id,
                              vlans: "",
                              color: "",
                              cablename: ""})
    end
  end

  def execute_movement(apply_connections: true)
    equipment = self.moveable
    equipment.frame = self.frame
    equipment.position = self.position
    if equipment.save
      if apply_connections
        MovedConnection.per_servers([equipment]).map(&:execute_movement)
      end
      self.delete
    end
  end
end
