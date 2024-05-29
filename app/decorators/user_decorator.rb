# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  class << self
    def available_locales_for_options
      User::AVAILABLE_LOCALES.map { |locale| [User.human_attribute_name("locale.#{locale}"), locale] }
    end

    def available_background_colors_for_options
      User::AVAILABLE_BAY_BACKGROUND_COLORS.map { |bg_color| [User.human_attribute_name("visualization_bay_default_background_color.#{bg_color}"), bg_color] }
    end

    def available_bay_orientations_for_options
      User::AVAILABLE_BAY_ORIENTATIONS.map { |orientation| [User.human_attribute_name("visualization_bay_default_orientation.#{orientation}"), orientation] }
    end
  end
end
