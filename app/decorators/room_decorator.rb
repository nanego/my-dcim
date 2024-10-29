# frozen_string_literal: true

class RoomDecorator < ApplicationDecorator
  BADGE_COLORS = {
    active: "text-bg-success",
    passive: "text-bg-warning",
    planned: "text-bg-primary"
  }.freeze

  class << self
    def statuses_for_options
      Room.statuses.keys.map { |status| [Room.human_attribute_name("status.#{status}"), status] }
    end
  end

  def badge_color_for_status
    BADGE_COLORS[status.to_sym]
  end
end
