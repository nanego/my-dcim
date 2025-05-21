# frozen_string_literal: true

class Move < ApplicationRecord
  has_changelog

  belongs_to :step, class_name: "MovesProjectStep", foreign_key: :moves_project_step_id, inverse_of: :moves
  belongs_to :moveable, polymorphic: true
  belongs_to :frame
  belongs_to :prev_frame, class_name: "Frame"

  validates :position, presence: true

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
      MovedConnection.per_servers([equipment]).map(&:execute_movement) if apply_connections

      delete
    end
  end
end
