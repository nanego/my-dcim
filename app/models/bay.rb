# frozen_string_literal: true

class Bay < ApplicationRecord
  has_changelog
  acts_as_list scope: [:lane, :islet_id]

  belongs_to :bay_type
  belongs_to :islet
  has_one :room, through: :islet
  has_many :frames, dependent: :restrict_with_error
  has_many :materials, through: :frames
  has_many :air_conditioners, dependent: :restrict_with_error

  scope :sorted, -> { order(:lane, :position) }

  scope :sorted_by_room, -> { joins(:room, :islet).order(:site_id, 'rooms.position', 'rooms.name', 'islets.name', :lane, 'bays.position') }

  def to_s
    frames.map(&:name).sort.join(' / ')
  end

  def detailed_name
    "#{room} #{islet.blank? ? "" : "Ilot #{islet.name}"}#{lane.blank? ? "" : " Ligne #{lane}"}#{position.blank? ? "" : " Position #{position}"}#{frames.any? ? " (#{list_frames})" : ""}"
  end

  def list_frames
    frames.pluck(:name).join(' / ')
  end
end
