class MemoryComponent < ActiveRecord::Base

  belongs_to :server
  belongs_to :memory_type

  def to_s
    "#{quantity} x #{memory_type}"
  end

end
