# frozen_string_literal: true

class Bay < ApplicationRecord
  has_changelog
  acts_as_list scope: %i[lane islet_id]

  belongs_to :bay_type
  belongs_to :islet
  belongs_to :manufacturer, optional: true, counter_cache: true
  has_one :room, through: :islet
  has_many :frames, dependent: :restrict_with_error
  has_many :materials, through: :frames
  has_many :air_conditioners, dependent: :restrict_with_error

  enum :access_control, { badge: 0, key: 1, locken_key: 2 }

  scope :sorted, -> { order(:lane, :position) }

  scope :sorted_by_room, -> { joins(:room, :islet).order(:site_id, 'rooms.position', 'rooms.name', 'islets.name', :lane, 'bays.position') }

  def to_s
    frames.any? ? list_frames : I18n.t("bays.empty")
  end

  def detailed_name
    "#{room} #{islet.blank? ? "" : "Ilot #{islet.name}"}#{lane.blank? ? "" : " Ligne #{lane}"}#{position.blank? ? "" : " Position #{position}"}#{frames.any? ? " (#{list_frames})" : ""}"
  end

  def list_frames
    frames.pluck(:name).sort.join(' / ')
  end
end
