class BayType < ActiveRecord::Base

  has_many :bays

  def to_s
    name.nil? ? "" : name
  end

end
