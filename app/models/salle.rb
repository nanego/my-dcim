class Salle < ActiveRecord::Base

  has_many :serveurs, through: :baies
  has_many :baies, -> { order("baies.ilot asc, baies.position asc") }

  def to_s
    title
  end
end
