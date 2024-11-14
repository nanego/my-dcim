# frozen_string_literal: true

class ContactRole < ApplicationRecord
  has_changelog

  has_many :contact_assignments, dependent: :restrict_with_error

  validates :name, presence: true

  def to_s
    name
  end
end
