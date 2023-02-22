# frozen_string_literal: true

class Disk < ApplicationRecord
  belongs_to :server
  belongs_to :disk_type

  def to_s
    "#{quantity} x #{disk_type}"
  end
end
