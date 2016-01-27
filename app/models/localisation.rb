class Localisation < ActiveRecord::Base

  has_many :serveurs

  def to_s
    title
  end
end
