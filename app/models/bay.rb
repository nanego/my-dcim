class Bay < ActiveRecord::Base

  belongs_to :bay_type
  belongs_to :islet
  has_many :frames

  default_scope { order( :position ) }

  def to_s
    name
  end

end
