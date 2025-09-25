# frozen_string_literal: true

class Architecture < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }

  delegate :to_s, to: :name
end
