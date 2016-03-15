class Baie < ActiveRecord::Base

  has_many :serveurs
  belongs_to :salle

end
