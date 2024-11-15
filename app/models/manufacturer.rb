# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error
  has_many :bays, dependent: :restrict_with_error

  scope :sorted, -> { order(:name) }

  def to_s
    name.to_s
  end
end
