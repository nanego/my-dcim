class Room < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :islets #, -> { order("islets.position asc") }
  has_many :bays, through: :islets
  has_many :frames, through: :bays
  has_many :servers, through: :frames

  belongs_to :site

  scope :sorted, -> { order( :position ) }
  scope :not_empty, -> { joins(:servers) }

  def to_s
    title.nil? ? "" : title
  end

  def name_with_site
    title.nil? ? site : "#{site} - #{title}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  private

    def slug_candidates
      [
          :title,
          [:title, :id]
      ]
    end

end
