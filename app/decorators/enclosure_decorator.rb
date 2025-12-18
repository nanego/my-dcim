# frozen_string_literal: true

class EnclosureDecorator < ApplicationDecorator
  def display_name
    "#{position} - #{display} - #{grid_areas}"
  end
end
