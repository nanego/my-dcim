# frozen_string_literal: true

class BadgeComponentPreview < ViewComponent::Preview
  # @param color select { choices: [primary, secondary, success, info, warning, danger, light, dark] }
  # @param type select { choices: [default, pill] }
  def default(color: :primary, type: :default)
    render BadgeComponent.new("Badge", color:, type:)
  end

  # @!group Colors
  def color_default
    render BadgeComponent.new("Badge", color: :primary)
  end

  def color_secondary
    render BadgeComponent.new("Badge", color: :secondary)
  end

  def color_success
    render BadgeComponent.new("Badge", color: :success)
  end

  def color_info
    render BadgeComponent.new("Badge", color: :info)
  end

  def color_warning
    render BadgeComponent.new("Badge", color: :warning)
  end

  def color_danger
    render BadgeComponent.new("Badge", color: :danger)
  end

  def color_light
    render BadgeComponent.new("Badge", color: :light)
  end

  def color_dark
    render BadgeComponent.new("Badge", color: :dark)
  end
  # @!endgroup

  # @!group Types
  def type_default
    render BadgeComponent.new("Badge", type: :default)
  end

  def type_pill
    render BadgeComponent.new("Badge", type: :pill)
  end
  # @!endgroup
end
