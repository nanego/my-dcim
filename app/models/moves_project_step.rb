# frozen_string_literal: true

class MovesProjectStep < ApplicationRecord
  class PreviousMovesNotExecutedError < StandardError; end

  has_changelog

  belongs_to :moves_project
  has_many :moves, dependent: :restrict_with_error

  acts_as_list scope: :moves_project

  validates :name, presence: true

  def to_s
    name
  end

  def execute!(apply_connections: true)
    raise PreviousMovesNotExecutedError unless prev_moves_executed?

    transaction do
      moves.find_each { |move| move.execute!(apply_connections:) }
    end
  end

  def executed?
    moves.any?(&:executed?)
  end

  def prev_moves_executed?
    Move.where(step: previous_steps, executed_at: nil).none?
  end

  def frames
    @frames = Frame.where(id: moves.select(:frame_id)).or(Frame.where(id: moves.select(:prev_frame_id))).order(:name)
  end

  def frames_with_moves_at_current_step
    @frames_with_moves_at_current_step ||= begin
      moves = Move.includes(:frame, :prev_frame)
        .where(step: moves_project.steps.where(position: ..position))

      (moves.map(&:frame) | moves.map(&:prev_frame)).compact.uniq.sort_by(&:name)
    end
  end

  # Returns servers, that will be present in given frame after
  # execution of current and previous steps.
  def servers_at_current_step_for(frame)
    # Servers that will arrive on the frame
    moved = server_moves_planned_at_current_step
      .where(frame:)
      .sort_by { |move| move.step.position }
      .map do |move|
        move.moveable.position = move.position
        move.moveable
      end

    # Servers that will leave frame or stay in the same frame
    removed = server_moves_planned_at_current_step
      .where(prev_frame: frame)
      .where.not(frame:)
      .map(&:moveable)

    # Merge servers that will be moved to the given frame with servers that are already here,
    # then remove those that will leave.
    ((moved | frame.servers) - removed).sort_by { |server| server.position.presence || 0 }.reverse
  end

  def previous_steps
    return nil unless moves_project&.steps

    moves_project.steps.where(position: ...position).order(:position)
  end

  def previous_step
    previous_steps&.last
  end

  private

  def server_moves_planned_at_current_step
    Move.not_executed
      .where(step: moves_project.steps.where(position: ..position))
      .where(moveable_type: "Server")
  end
end
