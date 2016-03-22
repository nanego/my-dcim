class Salle < ActiveRecord::Base

  has_many :serveurs
  has_many :baies

  def to_s
    title
  end
end
