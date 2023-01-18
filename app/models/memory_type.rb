# frozen_string_literal: true

class MemoryType < ApplicationRecord
  UNITS = ["Gb"]

  has_many :memory_components

  def to_s
    "#{quantity}#{unit}"
  end
end
