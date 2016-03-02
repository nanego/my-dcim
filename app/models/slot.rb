class Slot < ActiveRecord::Base

  belongs_to :composant

  acts_as_list scope: :composant

  def to_s
    valeur
  end
end
