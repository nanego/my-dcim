# frozen_string_literal: true

class PortType < ApplicationRecord
  has_changelog

  has_many :card_types, dependent: :restrict_with_error
  has_many :sockets, class_name: "PowerDistributionUnit::Socket", dependent: :restrict_with_error

  scope :sorted, -> { order(name: :asc) }
  scope :power_ones, -> { where(is_power: true) }

  delegate :to_s, to: :name
end
