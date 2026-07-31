# frozen_string_literal: true

class PortType < ApplicationRecord
  has_changelog

  has_many :card_types, dependent: :restrict_with_error
  has_many :sockets, class_name: "PowerDistributionUnit::Socket", dependent: :restrict_with_error

  validates :usable_by, array_inclusion: { in: %w[pdu server] }

  scope :sorted, -> { order(name: :asc) }
  scope :power_ones, -> { where(is_power: true) }
  scope :usable_by, ->(usable_by) { where("? = ANY(usable_by)", usable_by) }

  delegate :to_s, to: :name
end
