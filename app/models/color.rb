# frozen_string_literal: true

class Color < ApplicationRecord
  has_changelog

  def to_s
    code
  end
end
