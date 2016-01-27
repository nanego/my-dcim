class Slot < ActiveRecord::Base

  belongs_to :serveur

  def to_s
    valeur
  end
end
