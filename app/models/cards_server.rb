class CardsServer < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :card => :card,
      :server => :server,
      :composant => :composant
  }

  belongs_to :card
  belongs_to :server
  belongs_to :composant

  has_many :ports

end
