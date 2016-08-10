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

  def coupled_baies
    coupled_baies = []
    self.baies.each do |baie|
      if baie.couple_baie.present?
        coupled_baies << baie
      end
    end
    coupled_baies
  end

  def isolated_baies
    isolated_baies = []
    self.baies.each do |baie|
      if baie.has_no_coupled_baie?
        isolated_baies << baie
      end
    end
    isolated_baies
  end

  private

    def slug_candidates
      [
          :title,
          [:title, :id]
      ]
    end

end
