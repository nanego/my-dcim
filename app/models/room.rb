# frozen_string_literal: true

class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]

  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }

  has_many :islets, dependent: :restrict_with_error
  has_many :bays, through: :islets
  has_many :frames, through: :bays
  has_many :materials, through: :frames

  belongs_to :site, optional: true

  scope :sorted, -> { order( :position, :site_id, :name ) }
  scope :not_empty, -> { joins(:servers) }

  def to_s
    name.to_s
  end

  def name_with_site
    [site, name].join(' - ')
  end

  def should_generate_new_friendly_id?
    slug.blank? || name_changed?
  end

  private

    def slug_candidates
      [
          :name,
          [:name, :id]
      ]
    end
end
