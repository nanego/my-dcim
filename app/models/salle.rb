class Salle < ActiveRecord::Base

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :serveurs, through: :baies
  has_many :baies, -> { order("baies.ilot asc, baies.position asc") }

  def to_s
    title
  end
end
