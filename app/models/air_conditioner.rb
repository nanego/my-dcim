# frozen_string_literal: true

class AirConditioner < ApplicationRecord
  has_changelog

  belongs_to :bay
  belongs_to :air_conditioner_model

  has_one :room, through: :bay
  has_one :islet, through: :bay

  enum :status, { on: "on", degraded: "degraded", off: "off" }
  enum :position, { left: "left", right: "right" }

  validates :status, inclusion: { in: statuses.values }
  validates :position, inclusion: { in: positions.values }

  def to_s
    name
  end
end
