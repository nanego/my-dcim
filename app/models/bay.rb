class Bay < ActiveRecord::Base

  belongs_to :bay_type
  belongs_to :islet
  has_one :room, through: :islet
  has_many :frames
  has_many :servers, through: :frames

  default_scope { order( :lane, :position ) }

  def to_s
    name
  end

end
