# frozen_string_literal: true

class PortType < ApplicationRecord
  has_changelog

  has_many :card_types, dependent: :restrict_with_error
  has_many :sockets, class_name: "PowerDistributionUnit::Socket", dependent: :restrict_with_error

  validates :attachable_to, array_inclusion: { in: %w[pdu server] }

  scope :sorted, -> { order(name: :asc) }

  delegate :to_s, to: :name

  def is_power?
    is_power
  end
end
