# frozen_string_literal: true

class MovesProjectStep < ApplicationRecord
  has_changelog

  belongs_to :moves_project

  acts_as_list scope: :moves_project

  validates :name, presence: true

  def to_s
    name
  end
end
