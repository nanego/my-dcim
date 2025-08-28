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

  def servers_moves_for_frame_at_current_step(frame)
    moved = Move.includes(:frame)
      .not_executed
      .where(step: moves_project.steps.where(position: ..position))
      .where(frame:, moveable_type: "Server")
      .sort_by { |move| move.step.position }
      .map do |move|
      move.moveable.position = move.position
      move.moveable
    end

    removed = Move.includes(:prev_frame)
      .not_executed
      .where(step: moves_project.steps.where(position: ..position))
      .where(prev_frame: frame, moveable_type: "Server")
      .where.not("prev_frame_id = :frame AND frame_id = :frame", frame:)
      .map(&:moveable)

    ((moved | frame.servers) - removed).sort_by { |server| server.position.presence || 0 }.reverse
  end

  def previous_steps
    return nil unless moves_project&.steps

    moves_project.steps.where(position: ...position).order(:position)
  end

  def previous_step
    previous_steps&.last
  end
end
