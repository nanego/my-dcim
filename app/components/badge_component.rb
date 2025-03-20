# frozen_string_literal: true

class BadgeComponent < ApplicationComponent
  COLORS = %i[primary secondary success info warning danger light dark].freeze
  VARIANTS = %i[default pill].freeze

  def initialize(text = nil, variant: :default, color: :primary)
    @text = text

    @variant = variant.to_sym
    raise ArgumentError, "'#{@variant.inspect}' is not a valid variant" unless VARIANTS.include?(@variant)

    @color = color.to_sym
    raise ArgumentError, "'#{@color.inspect}' is not a valid color" unless COLORS.include?(@color)

    super()
  end

  def call
    tag.span(class: css_classes) do
      content
    end
  end

  def css_classes
    class_names("badge", "text-#{@color}-emphasis bg-#{@color}-subtle border border-#{@color}-subtle",
                "rounded-pill": @variant == :pill)
  end

  def content
    super || @text
  end
end
