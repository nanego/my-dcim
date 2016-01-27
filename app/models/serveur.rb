class Serveur < ActiveRecord::Base

  belongs_to :acte
  belongs_to :salle
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :marque
  belongs_to :architecture
  belongs_to :categorie
  belongs_to :armoire
  belongs_to :localisation

  has_many :slots

end
