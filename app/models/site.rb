# frozen_string_literal: true

class Site < ApplicationRecord
  geocoded_by :address
  after_validation :geocode

  has_many :rooms

  scope :sorted, -> { order(:position) }

  def to_s
    name
  end

  def address
    [street, city, country].compact.join(', ')
  end
end
