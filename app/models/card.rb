class Card < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  belongs_to :port_type
  has_many :cards_serveurs
  has_many :serveurs, through: :cards_serveurs

end
