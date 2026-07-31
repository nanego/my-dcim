# frozen_string_literal: true

class PowerDistributionUnitDecorator < ApplicationDecorator
  class << self
    def options_for_select
      PowerDistributionUnit.includes(:frame).select(:id, :frame_id, :power_line).map { |p| [p.name, p.id] }
    end

    def rooms_options_for_select(user)
      RoomDecorator.options_for_select(user)
    end

    def islets_options_for_select(user)
      IsletDecorator.options_for_select(user)
    end

    def bays_options_for_select(user)
      BayDecorator.options_for_select(user)
    end

    def frames_options_for_select(user)
      FrameDecorator.options_for_select(user)
    end

    def power_distribution_unit_types_options_for_select
      PowerDistributionUnitTypeDecorator.options_for_select
    end

    def manufacturers_options_for_select
      ManufacturerDecorator.options_for_select
    end

    def side_options_for_select
      PowerDistributionUnit.sides.keys.map do |side|
        [PowerDistributionUnit.human_attribute_name("side.#{side}"), side]
      end
    end

    def orientation_options_for_select
      PowerDistributionUnit.orientations.keys.map do |orientation|
        [PowerDistributionUnit.human_attribute_name("orientation.#{orientation}"), orientation]
      end
    end

    def power_line_options_for_select
      PowerDistributionUnit.power_lines.keys.map do |power_line|
        [power_line.upcase, power_line]
      end
    end
  end

  def full_location
    [site, islet.decorated.name_with_room].compact_blank.join(" - ")
  end

  def in_frame_location
    [frame, PowerDistributionUnit.human_attribute_name("side.#{side}").first].compact_blank.join(" - ")
  end
end
