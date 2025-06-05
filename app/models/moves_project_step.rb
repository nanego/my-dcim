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

  def frames_with_effective_moves
    @frames_with_effective_moves ||= begin
      moves = Move.includes(:frame, :prev_frame)
        .where(step: moves_project.steps.where(position: ..position))
        .not_executed

      (moves.map(&:frame) | moves.map(&:prev_frame)).compact.uniq
    end
  end
end
