# frozen_string_literal: true

class PowerDistributionUnit < ApplicationRecord
  has_changelog

  belongs_to :type, class_name: "PowerDistributionUnitType"
  belongs_to :bay

  has_one :manufacturer, through: :type
  has_one :islet, through: :bay
  has_one :room, through: :bay

  enum :orientation, { asc: 0, desc: 1 }, validate: true
  enum :side, { left: 0, right: 1 }, validate: true

  validates :name, presence: true

  delegate :to_s, to: :name
end
