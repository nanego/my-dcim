# frozen_string_literal: true

class Move < ApplicationRecord
  has_changelog

  attr_accessor :remove_connections

  belongs_to :step, class_name: "MovesProjectStep", foreign_key: :moves_project_step_id, inverse_of: :moves
  belongs_to :moveable, polymorphic: true
  belongs_to :frame
  belongs_to :prev_frame, class_name: "Frame"

  validates :position, presence: true

  before_validation :refresh_prev_data
  before_save :refresh_prev_data

  scope :not_executed, -> { where(executed_at: nil) }

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

  def status
    executed? ? :executed : :planned
  end

  def execute!(apply_connections: true)
    return if executed?

    transaction(requires_new: true) do
      equipment = moveable
      equipment.frame = frame
      equipment.position = position

      if equipment.save!
        MovedConnection.per_servers([equipment]).map(&:execute!) if apply_connections

        # Update prev_frame and prev_position for incoming moves
        Move.not_executed
          .where(moveable: equipment)
          .where.not(id: self)
          .find_each do |move|
            move.update(prev_frame_id: frame.id, prev_position: position)
          end

        update!(executed_at: Time.zone.now)
      end
    end
  end

  def executed?
    executed_at?
  end

  def refresh_prev_data
    return if executed?
    return unless moveable

    self.prev_frame_id = moveable.frame_id
    self.prev_position = moveable.position
  end
end
