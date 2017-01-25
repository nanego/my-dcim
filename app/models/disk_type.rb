class DiskType < ActiveRecord::Base

  UNITS = ["Tb", "Gb"]
  TECHNOLOGIES = ["", "SSD"]

  has_many :disks

  def to_s
    "#{technology ? technology+' ' : ''}#{quantity} #{unit}"
  end
end
