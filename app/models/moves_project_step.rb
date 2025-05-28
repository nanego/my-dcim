# frozen_string_literal: true

class MovesProjectStep < ApplicationRecord
  has_changelog

  belongs_to :moves_project
  has_many :moves, dependent: :restrict_with_error

  validates :name, presence: true

  def to_s
    name
  end
end
