# frozen_string_literal: true

class BayType < ApplicationRecord
  has_changelog

  has_many :bays

  def to_s
    name.to_s
  end
end
