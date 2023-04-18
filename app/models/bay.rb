# frozen_string_literal: true

class Bay < ApplicationRecord
  belongs_to :bay_type
  belongs_to :islet
  has_one :room, through: :islet
  has_many :frames, dependent: :restrict_with_error
  has_many :materials, through: :frames

  acts_as_list scope: [:lane, :islet_id]

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
