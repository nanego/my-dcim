# frozen_string_literal: true

class Islet < ApplicationRecord
  has_changelog

  belongs_to :room, counter_cache: true
  has_one :site, through: :room
  has_many :bays, dependent: :restrict_with_error
  has_many :frames, through: :bays
  has_many :servers, through: :frames
  has_many :materials, through: :frames

  scope :sorted, -> { order(:room_id, :position, :name) }
  scope :not_empty, -> { joins(:materials) }
  scope :has_name, -> { where.not(name: nil) }

  def to_s
    name.to_s
  end

  def name_with_room
    "#{room} #{name.blank? ? "" : 'Ilot ' + name}"
  end
end
