class Salle < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :serveurs, through: :baies
  has_many :baies, -> { order("baies.ilot asc, baies.position asc") }

  def to_s
    title
  end

  private

    def slug_candidates
      [
          :title,
          [:title, :id]
      ]
    end

end
