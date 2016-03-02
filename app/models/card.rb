class Card < ActiveRecord::Base

  belongs_to :port_type
  has_many :cards_serveurs
  has_many :serveurs, through: :cards_serveurs

end
