# frozen_string_literal: true

class Bay < ApplicationRecord
  has_changelog

  belongs_to :bay_type
  belongs_to :islet
  belongs_to :manufacturer, optional: true, counter_cache: true
  has_one :room, through: :islet
  has_many :frames, dependent: :restrict_with_error
  has_many :materials, through: :frames
  has_many :air_conditioners, dependent: :restrict_with_error

  enum :access_control, { badge: 0, key: 1, locken_key: 2 }

  validates :position, uniqueness: { scope: %i[islet_id lane] }

  before_create :set_lane
  before_create :set_position

  scope :sorted, -> { order(:lane, :position) }
  scope :sorted_by_room, -> { joins(:room, :islet).order(:site_id, "rooms.position", "rooms.name", "islets.name", :lane, "bays.position") }

  def to_s
    frames.any? ? list_frames : I18n.t("bays.empty")
  end

  def detailed_name
    "#{room} #{"Ilot #{islet.name}" if islet.present?}#{" Ligne #{lane}" if lane.present?}#{" Position #{position}" if position.present?}#{" (#{list_frames})" if frames.any?}"
  end

  def list_frames
    frames.pluck(:name).sort.join(" / ")
  end

  def last_lane_used
    @last_lane_used ||= islet.bays.maximum(:lane) || 1
  end

  def set_lane
    return if lane.present?

    self.lane = last_lane_used
  end

  def last_position_used
    @last_position_used ||= islet.bays.where(lane:).maximum(:position) || 0
  end

  def next_free_position
    last_position_used + 1
  end

  def set_position
    return if position.present?

    self.position = next_free_position
  end
end
