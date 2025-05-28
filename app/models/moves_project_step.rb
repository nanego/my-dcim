# frozen_string_literal: true

class MovesProjectStep < ApplicationRecord
  has_changelog

  belongs_to :moves_project
  has_many :moves, dependent: :restrict_with_error

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
end
