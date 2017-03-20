class Site < ActiveRecord::Base

  has_many :rooms

  def to_s
    name
  end

end
