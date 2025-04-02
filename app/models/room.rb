# frozen_string_literal: true

class Room < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidates, use: %i[slugged history]

  has_changelog

  belongs_to :site, counter_cache: true

  has_many :cluster_rooms, dependent: :destroy
  has_many :network_clusters, class_name: "Cluster", through: :cluster_rooms, source: :cluster

  has_many :islets, dependent: :restrict_with_error
  has_many :bays, through: :islets, dependent: :restrict_with_error
  has_many :frames, through: :bays, dependent: :restrict_with_error
  has_many :materials, through: :frames, dependent: :restrict_with_error

  enum :status, { active: 0, passive: 1, planned: 2 }, validate: true
  enum :access_control, { badge: 0, key: 1, locken_key: 2 }

  scope :sorted, -> { order(:site_id, :position, :name) }
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

  def network_cluster(network_types:)
    NetworkCluster.new(room: self, network_types:)
  end

  private

  def slug_candidates
    [
      :name,
      %i[name id],
    ]
  end
end
