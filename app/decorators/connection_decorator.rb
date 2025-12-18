# frozen_string_literal: true

class ConnectionDecorator < ApplicationDecorator
  def display_name
    return "n/c" unless server

    "#{server} - #{card}"
  end
end
