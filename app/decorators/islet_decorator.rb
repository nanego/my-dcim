# frozen_string_literal: true

class IsletDecorator < ApplicationDecorator
  include Rails.application.routes.url_helpers

  class << self
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

  def cooling_mode_to_human
    return Islet.human_attribute_name("cooling_mode.blank") unless (c_m = cooling_mode.presence)

    Islet.human_attribute_name("cooling_mode.#{c_m}")
  end

  def access_control_to_human
    return I18n.t("access_control.blank") unless (a_c = access_control.presence)

    I18n.t("access_control.#{a_c}")
  end

  def overviewed_bays_array
    @overviewed_bays_array ||= bays.sorted.group_by(&:lane).map do |_, bays|
      Array.new(bays.last.position) do |i|
        (bay = bays.to_a.find { |b| b.position == i + 1 }) ? bay : :no_bay
      end
    end.flatten
  end

  def print_frames_paths(**)
    frames.order(:name).pluck(:id).map do |frame_id|
      print_visualization_frame_path(frame_id, **)
    end
  end
end
