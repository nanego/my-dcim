# frozen_string_literal: true

class MovesProject < ApplicationRecord
  has_changelog

  validates :name, presence: true

  def to_s
    name
  end
end
