# frozen_string_literal: true

class ContactRole < ApplicationRecord
  has_changelog

  validates :name, presence: true

  def to_s
    name
  end
end
