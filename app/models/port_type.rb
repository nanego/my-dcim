# frozen_string_literal: true

class PortType < ApplicationRecord
  has_changelog

  has_many :card_types, dependent: :restrict_with_error

  scope :sorted, -> { order(name: :asc) }

  delegate :to_s, to: :name

  def is_power_input?
    name == "ALIM"
  end
end
