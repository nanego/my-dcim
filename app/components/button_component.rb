# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  VARIANTS = %i[default primary secondary success danger warning info light dark link].freeze
  SIZES = %i[sm default lg].freeze

  def initialize(title:, url:, variant: :default, size: :default, icon: nil, is_responsive: false, extra_classes: "")
    @title = title
    @url = url
    @variant = variant&.to_sym
    @size = size.to_sym
    @icon = icon
    @is_responsive = is_responsive
    @extra_classes = extra_classes

    raise ArgumentError, "'#{@variant.inspect}' is not a valid variant type" unless VARIANTS.include?(@variant)
    raise ArgumentError, "'#{@size.inspect}' is not a valid size type" unless SIZES.include?(@size)

    super
  end

  def call
    link_to @url,
            class: "btn btn-#{@variant} btn-#{@size} align-self-center d-inline-flex #{@extra_classes}",
            title: @title do
      concat(tag.span(class: "bi bi-#{@icon}"))
      concat(tag.span(@title, class: class_names("ms-1", 'd-none d-md-inline-block': @is_responsive)))
    end
  end
end
