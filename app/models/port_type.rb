# frozen_string_literal: true

class PortType < ApplicationRecord
  has_many :card_types

  def is_power_input?
    name=='ALIM'
  end
end
