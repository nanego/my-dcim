# frozen_string_literal: true

class BadgeComponentPreview < ViewComponent::Preview
  # @param text "Content of badge"
  # @param color select :color_options
  # @param type select :type_options
  def default(text: "Badge", color: :primary, type: :default)
    render BadgeComponent.new(text, color:, type:)
  end

  # @!group Colors

  # @param text "Content of badge"
  # @param type select :type_options
  def color_default(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :primary, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_secondary(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :secondary, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_success(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :success, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_info(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :info, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_warning(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :warning, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_danger(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :danger, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_light(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :light, type:)
  end

  # @param text "Content of badge"
  # @param type select :type_options
  def color_dark(text: "Badge", type: :default)
    render BadgeComponent.new(text, color: :dark, type:)
  end
  # @!endgroup

  # @!group Types

  # @param text "Content of badge"
  # @param color select :color_options
  def type_default(text: "Badge", color: :primary)
    render BadgeComponent.new(text, color:, type: :default)
  end

  # @param text "Content of badge"
  # @param color select :color_options
  def type_pill(text: "Badge", color: :primary)
    render BadgeComponent.new(text, color:, type: :pill)
  end
  # @!endgroup

  private

  def color_options
    BadgeComponent::COLORS
  end

  def type_options
    BadgeComponent::TYPES
  end
end
