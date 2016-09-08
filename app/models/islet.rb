class Islet < ActiveRecord::Base

  belongs_to :room
  has_many :bays

  def to_s
    name
  end

end
