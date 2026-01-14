# frozen_string_literal: true

class Cluster < ApplicationRecord
  has_changelog

  has_many :servers, dependent: :restrict_with_error
  has_many :cluster_rooms, dependent: :destroy

  scope :sorted, -> { order(Arel.sql("LOWER(name)")) }

  def to_s
    name.presence || " "
  end
end
