class MemoryType < ActiveRecord::Base

  UNITS = ["Gb"]

  has_many :memory_components, dependent: :restrict_with_error

  def to_s
    "#{quantity}#{unit}"
  end
end
