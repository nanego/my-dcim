class Room < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :islets

  has_many :servers, through: :frames
  has_many :frames, -> { order("frames.ilot asc, frames.position asc") }

  def to_s
    title
  end

  def coupled_frames
    coupled_frames = []
    self.frames.each do |frame|
      if frame.couple_frame.present?
        coupled_frames << frame
      end
    end
    coupled_frames
  end

  def isolated_frames
    isolated_frames = []
    self.frames.each do |frame|
      if frame.has_no_coupled_frame?
        isolated_frames << frame
      end
    end
    isolated_frames
  end

  private

    def slug_candidates
      [
          :title,
          [:title, :id]
      ]
    end

end
