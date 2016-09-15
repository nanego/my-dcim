class Bay < ActiveRecord::Base

  belongs_to :bay_type
  belongs_to :islet
  has_one :room, through: :islet
  has_many :frames
  has_many :servers, through: :frames

  scope :sorted, -> { order( :lane, :position ) }

  def to_s
    name
  end

end
