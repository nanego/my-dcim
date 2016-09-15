class Islet < ActiveRecord::Base

  belongs_to :room
  has_many :bays

  scope :sorted, -> { order( :name ) }

  def to_s
    name
  end

end
