class DiskType < ActiveRecord::Base

  UNITS = ["Tb", "Gb"]
  TECHNOLOGIES = ["", "SSD"]

  has_many :disks, dependent: :restrict_with_error

  def to_s
    "#{technology ? technology+' ' : ''}#{quantity} #{unit}"
  end
end
