# frozen_string_literal: true

class AirConditioner < ApplicationRecord
  has_changelog

  belongs_to :bay
  belongs_to :air_conditioner_model

  has_one :room, through: :bay
  has_one :islet, through: :bay

  enum status: { on: 'on', off: 'off' }
  enum position: { left: 'left', right: 'right' }

  validates :status, inclusion: { in: %w[on off] }
  validates :position, inclusion: { in: %w[left right] }

  def to_s
    name
  end
end
