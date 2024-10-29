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

    def access_control_options_for_select
      Room.access_controls.keys.map { |a_c| [I18n.t("concerns.access_control.#{a_c}"), a_c] }
    end
  end

  def badge_color_for_status
    BADGE_COLORS[status.to_sym]
  end

  def access_control_to_human
    return I18n.t("concerns.access_control.blank") unless (a_c = access_control.presence)

    I18n.t("concerns.access_control.#{a_c}")
  end
end
