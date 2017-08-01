class Card < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  tracked :parameters => {
      :card_type => :card_type,
      :server => :server,
      :composant => :composant
  }

  belongs_to :card_type
  belongs_to :server
  belongs_to :composant

  has_many :ports

  scope :for_enclosure, ->  (enclosure_id) { joins(:composant).where("composants.enclosure_id = ?", enclosure_id)}

  def to_s
    "Carte #{server} / #{card_type} / #{composant}"
  end

end
