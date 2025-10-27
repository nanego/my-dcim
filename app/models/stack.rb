# frozen_string_literal: true

class Stack < ApplicationRecord
  has_changelog

  has_many :servers, dependent: :restrict_with_error

  def to_s
    name
  end
end
