# frozen_string_literal: true

class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :history]
  has_changelog

  belongs_to :site, optional: true

  has_many :islets, dependent: :restrict_with_error
  has_many :bays, through: :islets, dependent: :restrict_with_error
  has_many :frames, through: :bays, dependent: :restrict_with_error
  has_many :materials, through: :frames, dependent: :restrict_with_error

  scope :sorted, -> { order( :position, :site_id, :name ) }
  scope :not_empty, -> { joins(:servers) }

  def to_s
    name.to_s
  end

  def name_with_site
    [site, name].join(" - ")
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
