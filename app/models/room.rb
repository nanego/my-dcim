class Room < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :islets #, -> { order("islets.position asc") }
  has_many :bays, -> { order("bays.position asc") }, through: :islets
  has_many :frames, -> { order("frames.position asc") }, through: :bays
  has_many :servers, -> { order("servers.position asc") }, through: :frames

  scope :sorted, -> { order( :position ) }

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
