# frozen_string_literal: true

class UserDecorator < ApplicationDecorator
  class << self
    def available_locales_options_for_select
      User::AVAILABLE_LOCALES.map { |locale| [User.human_attribute_name("locale.#{locale}"), locale] }
    end

    def available_themes_options_for_select
      User::AVAILABLE_THEMES.map { |theme| [User.human_attribute_name("theme.#{theme}"), theme] }
    end

    def available_background_colors_options_for_select
      User::AVAILABLE_BAY_BACKGROUND_COLORS.map { |bg_color| [User.human_attribute_name("visualization_bay_default_background_color.#{bg_color}"), bg_color] }
    end

    def available_bay_orientations_options_for_select
      User::AVAILABLE_BAY_ORIENTATIONS.map { |orientation| [User.human_attribute_name("visualization_bay_default_orientation.#{orientation}"), orientation] }
    end
  end

  def role_human_name
    User.human_attribute_name("role.#{writer? ? :writer : :reader}")
  end

  def role_to_badge_component
    return BadgeComponent.new(User.human_attribute_name("admin"), color: :warning) if is_admin

    color = writer? ? :primary : :info
    BadgeComponent.new(role_human_name, color:)
  end
end
