class CardsServeur < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :card
  belongs_to :serveur
  belongs_to :composant

  has_many :ports, :as => :parent

end
