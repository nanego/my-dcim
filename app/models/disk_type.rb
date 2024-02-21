# frozen_string_literal: true

class DiskType < ApplicationRecord
  UNITS = ["Tb", "Gb"]
  TECHNOLOGIES = ["", "SSD"]

  has_changelog

  has_many :disks, dependent: :restrict_with_error

  def to_s
    "#{technology ? technology + " " : ""}#{quantity} #{unit}"
  end
end
