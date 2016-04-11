class Salle < ActiveRecord::Base

  has_many :serveurs, through: :baies
  has_many :baies

  def to_s
    title
  end
end
