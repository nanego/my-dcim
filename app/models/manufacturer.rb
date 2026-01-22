# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error
  has_many :bays, dependent: :restrict_with_error
  has_many :servers, through: :modeles

  scope :sorted, -> { order(:name) }

  delegate :to_s, to: :name
end
