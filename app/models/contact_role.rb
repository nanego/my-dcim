# frozen_string_literal: true

class ContactRole < ApplicationRecord
  has_changelog

  def to_s
    name
  end
end
