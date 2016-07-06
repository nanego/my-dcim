class CardsServeur < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :card => :card,
      :serveur => :serveur,
      :composant => :composant
  }

  belongs_to :card
  belongs_to :serveur
  belongs_to :composant

  has_many :ports, :as => :parent

end
