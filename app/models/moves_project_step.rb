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
    moved = Move.includes(:frame, :prev_frame)
      .where(step: moves_project.steps.where(position: ..position))
      .where(frame:, moveable_type: "Server").map do |move|
      move.moveable.position = move.position
      move.moveable
    end

    removed = Move.includes(:frame, :prev_frame)
      .where(step: moves_project.steps.where(position: ..position))
      .where(prev_frame: frame, moveable_type: "Server").map(&:moveable)

    ((frame.servers - removed) | moved).sort_by { |server| server.position.presence || 0 }.reverse
  end
end
