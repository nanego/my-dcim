# frozen_string_literal: true

class PortType < ApplicationRecord
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  has_changelog

  has_many :card_types

  def to_s
    name.to_s
  end

  def is_power_input?
    name == "ALIM"
  end
end
