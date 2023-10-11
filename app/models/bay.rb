# frozen_string_literal: true

class Bay < ApplicationRecord
  has_changelog
  acts_as_list scope: [:lane, :islet_id]

  belongs_to :bay_type, optional: true
  belongs_to :islet, optional: true
  has_one :room, through: :islet
  has_many :frames, dependent: :restrict_with_error
  has_many :materials, through: :frames

  scope :sorted, -> { order( :lane, :position ) }

  def to_s
    frames.sorted.pluck(:name).join('/')
  end

  def detailed_name
    "#{room} #{islet.blank? ? "" : "Ilot #{islet.name}"}#{lane.blank? ? "" : " Ligne #{lane}"}#{position.blank? ? "":" Position #{position}"}#{frames.any? ? " (#{list_frames})" : ""}"
  end

  def list_frames
    frames.pluck(:name).join(' / ')
  end
end
