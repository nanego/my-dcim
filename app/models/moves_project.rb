# frozen_string_literal: true

class MovesProject < ApplicationRecord
  has_changelog

  has_many :steps, -> { order(:position) }, class_name: "MovesProjectStep", dependent: :restrict_with_error,
                                            inverse_of: :moves_project

  validates :name, presence: true

  def to_s
    name
  end
end
