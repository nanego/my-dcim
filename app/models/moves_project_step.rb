# frozen_string_literal: true

class MovesProjectStep < ApplicationRecord
  has_changelog

  belongs_to :moves_project
  has_many :moves, dependent: :restrict_with_error

  acts_as_list scope: :moves_project

  validates :name, presence: true

  def to_s
    name
  end

  def execute!(apply_connections: true)
    transaction do
      moves.find_each { |move| move.execute!(apply_connections:) }
    end
  end

  def executed?
    moves.any?(&:executed?)
  end

  def frames_with_moves_at_current_step
    @frames_with_moves_at_current_step ||= begin
      moves = Move.includes(:frame, :prev_frame)
        .where(step: moves_project.steps.where(position: ..position))

      (moves.map(&:frame) | moves.map(&:prev_frame)).compact.uniq
    end
  end

  # get servers, that will be present in frame after
  # the execution of current and previous steps
  def frame_servers_at_current_step_for(frame)
    # servers that arrives at frame
    moved = server_moves_involved_at_current_step
      .where(frame:)
      .sort_by { |move| move.step.position }
      .map do |move|
        move.moveable.position = move.position
        move.moveable
      end

    # servers that leave frame
    removed = server_moves_involved_at_current_step
      .where(prev_frame: frame)
      .where.not(frame:)
      .map(&:moveable)

    # merge servers that arrive with servers that are already here, then remove those that leave,
    # to get frame's servers after the execution of current and previous steps
    ((moved | frame.servers) - removed).sort_by { |server| server.position.presence || 0 }.reverse
  end

  def previous_steps
    return nil unless moves_project&.steps

    moves_project.steps.where(position: ...position).order(:position)
  end

  def previous_step
    previous_steps&.last
  end

  def server_moves_involved_at_current_step
    Move.not_executed
      .where(step: moves_project.steps.where(position: ..position))
      .where(moveable_type: "Server")
  end
end
