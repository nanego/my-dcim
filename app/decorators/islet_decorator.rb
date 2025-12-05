# frozen_string_literal: true

class IsletDecorator < ApplicationDecorator
  include Rails.application.routes.url_helpers

  class << self
    def options_for_select(user)
      islets = Islet.includes(:room)
        .sorted
        .order(
          "rooms.site_id", "rooms.position", "rooms.name",
        )

      authorized_scope(islets, user:).map { |i| [i.decorated.name_with_room, i.id] }
    end

    def sites_options_for_select(user)
      SiteDecorator.options_for_select(user)
    end

    def rooms_options_for_select(user)
      RoomDecorator.options_for_select(user)
    end

    def grouped_by_sites_options_for_select
      Islet.includes(:site, room: :islets).sorted.not_empty.has_name.distinct.group_by(&:site).to_h do |site, islets|
        islets = islets.map do |i|
          name = i.room.islets.size > 1 ? "#{i.room.name} Ilot #{i.name}" : i.room.name
          [name, i.id]
        end

        [site.name, islets]
      end
    end

    def cooling_modes_options_for_select
      Islet.cooling_modes.keys.map do |cooling_mode|
        [Islet.human_attribute_name("cooling_mode.#{cooling_mode}"), cooling_mode]
      end
    end

    def access_control_options_for_select
      Room.access_controls.keys.map { |a_c| [I18n.t("access_control.#{a_c}"), a_c] }
    end
  end

  def full_name
    [Islet.model_name.human, name].compact_blank.join(" ")
  end

  def name_with_room
    "#{full_name} #{room}"
  end

  def cooling_mode_to_human
    return Islet.human_attribute_name("cooling_mode.blank") unless (c_m = cooling_mode.presence)

    Islet.human_attribute_name("cooling_mode.#{c_m}")
  end

  def access_control_to_human
    return I18n.t("access_control.blank") unless (a_c = access_control.presence)

    I18n.t("access_control.#{a_c}")
  end

  def overviewed_bays_array(user)
    @overviewed_bays_array ||= BayDecorator.authorized_scope(bays, user:).sorted.group_by(&:lane).map do |lane, bays|
      [
        lane,
        Array.new(bays.last.position) do |i|
          (bay = bays.to_a.find { |b| b.position == i + 1 }) ? bay : :no_bay
        end,
      ]
    end
  end
end
