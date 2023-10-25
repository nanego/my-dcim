# frozen_string_literal: true

class Domaine < ApplicationRecord
  has_changelog

  has_many :servers, dependent: :restrict_with_error

  scope :sorted, -> {order(Arel.sql('LOWER(name)'))}

  def to_s
    name.to_s
  end
end
