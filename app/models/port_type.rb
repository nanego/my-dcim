# frozen_string_literal: true

class PortType < ApplicationRecord
  include Enum::Array

  has_changelog

  has_many :card_types, dependent: :restrict_with_error
  has_many :sockets, class_name: "PowerDistributionUnit::Socket", dependent: :restrict_with_error

  USABLE_BY_VALUES = %w[pdu server].freeze
  array_enum :usable_by, USABLE_BY_VALUES.index_with(&:to_s), validate: true

  scope :sorted, -> { order(name: :asc) }
  scope :power_ones, -> { where(is_power: true) }
  scope :usable_by, ->(usable_by) { where("? = ANY(usable_by)", usable_by) }

  delegate :to_s, to: :name
end
