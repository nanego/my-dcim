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
end
