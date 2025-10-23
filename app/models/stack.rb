# frozen_string_literal: true

class Stack < ApplicationRecord
  has_changelog

  has_many :servers, dependent: :restrict_with_error

  delete_dependency only: [:servers]

  def to_s
    name
  end
end
