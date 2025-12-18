# frozen_string_literal: true

class ConnectionDecorator < ApplicationDecorator
  def display_name
    "#{server} - #{card}"
  end
end
