# frozen_string_literal: true

class Disk < ApplicationRecord
  has_changelog

  belongs_to :server, optional: true
  belongs_to :disk_type, optional: true

  def to_s
    "#{quantity} x #{disk_type}"
  end
end
