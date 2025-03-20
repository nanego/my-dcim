# frozen_string_literal: true

class RoomDecorator < ApplicationDecorator
  BADGE_COLORS = {
    active: :success,
    passive: :warning,
    planned: :primary
  }.freeze

  class << self
    def statuses_for_options
      Room.statuses.keys.map { |status| [Room.human_attribute_name("status.#{status}"), status] }
    end

    def access_control_options_for_select
      Room.access_controls.keys.map { |a_c| [I18n.t("access_control.#{a_c}"), a_c] }
    end

    def network_clusters_options_for_select
      Cluster.pluck(:name, :id)
    end
  end

  def status_to_badge_component
    return { plain: nil } unless Room.statuses.key?(status)

    text = Room.human_attribute_name("status.#{status}")
    color = BADGE_COLORS[status.to_sym]

    BadgeComponent.new(text, color:, variant: :pill)
  end

  def access_control_to_human
    return I18n.t("access_control.blank") unless (a_c = access_control.presence)

    I18n.t("access_control.#{a_c}")
  end

  def network_clusters_to_sentence
    @network_clusters_to_sentence ||= network_clusters.pluck(:name).join(", ")
  end
end
