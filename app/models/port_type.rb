# frozen_string_literal: true

class PortType < ApplicationRecord
  has_changelog

  has_many :card_types

  scope :sorted, -> { order(name: :asc) }

  def to_s
    name.to_s
  end

  def is_power_input?
    name == "ALIM"
  end
end
