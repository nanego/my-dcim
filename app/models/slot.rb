class Slot < ActiveRecord::Base

  belongs_to :composant
  belongs_to :serveur

  acts_as_list scope: [:composant_id, :serveur_id]

  def to_s
    valeur
  end
end
