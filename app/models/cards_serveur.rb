class CardsServeur < ActiveRecord::Base

  belongs_to :card
  belongs_to :serveur
  belongs_to :composant

end
