class Serveur < ActiveRecord::Base

  belongs_to :acte
  belongs_to :salle
  belongs_to :baie
  belongs_to :gestion
  belongs_to :domaine
  belongs_to :modele
  belongs_to :armoire
  belongs_to :localisation

  has_many :slots
  has_many :cards_serveurs, -> { joins(:composant).order("position asc") }
  has_many :cards, through: :cards_serveurs

  accepts_nested_attributes_for :cards_serveurs,
                                :allow_destroy => true,
                                :reject_if     => :all_blank

end
