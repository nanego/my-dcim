class Bay < ActiveRecord::Base

  belongs_to :bay_type
  belongs_to :islet
  has_many :frames

  def to_s
    name
  end

end
