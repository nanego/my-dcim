class MemoryType < ActiveRecord::Base

  UNITS = ["Gb"]

  has_many :memory_components

  def to_s
    "#{quantity}#{unit}"
  end
end
