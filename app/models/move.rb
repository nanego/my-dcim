# frozen_string_literal: true

class Move < ApplicationRecord
  has_changelog

  belongs_to :step, class_name: "MovesProjectStep", foreign_key: :moves_project_step_id, inverse_of: :moves
  belongs_to :moveable, polymorphic: true
  belongs_to :frame
  belongs_to :prev_frame, class_name: "Frame"

  has_one :moves_project, through: :step

  validates :moveable_id, uniqueness: { scope: %i[step moveable_type] }

  validates :position, presence: true

  before_validation :refresh_prev_data
  before_save :refresh_prev_data

  scope :not_executed, -> { where(executed_at: nil) }

  def clear_connections_and_save
    clear_connections
    save
  end

  def moved_connections
    return [] unless moveable

    MovedConnection.per_servers([moveable])
  end

  def clear_connections
    return unless remove_existing_connections_on_execution

    # Delete current moved connections
    moved_connections.delete_all

    # Add moved connection for each port
    moveable.ports.each do |p|
      MovedConnection.create(
        port_from_id: p.id,
        vlans: "",
        color: "",
        cablename: "",
      )
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
        moved_connections.map(&:execute!) if apply_connections

        # Update prev_frame and prev_position for incoming moves
        Move.not_executed
          .where(moveable: equipment)
          .where.not(id: self)
          .find_each do |move|
            move.update(prev_frame_id: frame.id, prev_position: position)
          end

        update_columns(executed_at: Time.zone.now) # rubocop:disable Rails/SkipsModelValidations
      end
    end
  end

  def executed?
    executed_at?
  end

  def previous_moves
    return nil unless step&.previous_step

    step.previous_step.moves
  end

  def refresh_prev_data
    return if executed?
    return unless moveable

    if (move = previous_moves&.where(moveable:)&.last)
      prev_frame_id = move.frame_id
      prev_position = move.position
    end

    self.prev_frame_id = prev_frame_id || moveable.frame_id
    self.prev_position = prev_position || moveable.position
  end
end
