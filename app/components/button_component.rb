# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  VARIANTS = %i[default primary secondary success danger warning info light dark link outline_primary outline_danger].freeze
  SIZES = %i[sm default lg].freeze

  def initialize(title, url:, variant: :default, size: :default, icon: nil, is_responsive: false, extra_classes: "", **html_options) # rubocop:disable Metrics/ParameterLists
    @title = title
    @url = url
    @variant = variant&.to_sym
    @size = size.to_sym
    @icon = icon
    @is_responsive = is_responsive
    @extra_classes = extra_classes
    @html_options = html_options

    raise ArgumentError, "'#{@variant.inspect}' is not a valid variant type" unless VARIANTS.include?(@variant)
    raise ArgumentError, "'#{@size.inspect}' is not a valid size type" unless SIZES.include?(@size)

    super
  end

  def call
    link_to @url,
            class: "btn btn-#{@variant.to_s.dasherize} btn-#{@size} align-items-center d-inline-flex #{@extra_classes}",
            title: @html_options&.dig(:data, :tooltip_title) || @title,
            **@html_options do
      concat(tag.i(class: "bi bi-#{@icon}")) if @icon
      concat(tag.span(@title, class: class_names("ms-2", "d-none d-md-inline-flex": @is_responsive)))
    end
  end
end
