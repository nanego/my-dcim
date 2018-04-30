class BayType < ActiveRecord::Base

  has_many :bays

  def to_s
    name.to_s
  end

end
