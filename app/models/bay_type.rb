# frozen_string_literal: true

class BayType < ApplicationRecord
  has_changelog

  has_many :bays

  delegate :to_s, to: :name
end
