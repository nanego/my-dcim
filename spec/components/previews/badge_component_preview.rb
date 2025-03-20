# frozen_string_literal: true

class BadgeComponentPreview < ViewComponent::Preview
  # @param text "Content of badge"
  # @param color select :color_options
  # @param variant select :variant_options
  def default(text: "Badge", color: :primary, variant: :default)
    render BadgeComponent.new(text, color:, variant:)
  end

  # @!group Colors

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_default(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :primary, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_secondary(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :secondary, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_success(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :success, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_info(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :info, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_warning(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :warning, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_danger(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :danger, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_light(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :light, variant:)
  end

  # @param text "Content of badge"
  # @param variant select :variant_options
  def color_dark(text: "Badge", variant: :default)
    render BadgeComponent.new(text, color: :dark, variant:)
  end
  # @!endgroup

  # @!group Variants

  # @param text "Content of badge"
  # @param color select :color_options
  def variant_default(text: "Badge", color: :primary)
    render BadgeComponent.new(text, color:, variant: :default)
  end

  # @param text "Content of badge"
  # @param color select :color_options
  def variant_pill(text: "Badge", color: :primary)
    render BadgeComponent.new(text, color:, variant: :pill)
  end
  # @!endgroup

  private

  def color_options
    BadgeComponent::COLORS
  end

  def variant_options
    BadgeComponent::VARIANTS
  end
end
