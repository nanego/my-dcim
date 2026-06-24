# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  CREATE_ANOTHER_ONE_ACTIONS = %w[new create].freeze

  def accepted_format_for_attachment(model_klass, attribute_name)
    validator = model_klass.validators_on(attribute_name.to_sym).find do |v|
      v.is_a?(ActiveStorageValidations::ContentTypeValidator)
    end

    return unless validator

    validator.options[:in].map { |f| Mime[f].to_s }.uniq.join(", ")
  end

  def value_with_unit(value, unit)
    return if value.blank?

    "#{value} #{t("unit.#{unit}")}"
  end

  def surface_area_with_suffix(surface_area)
    value_with_unit(surface_area, "square_meter")
  end

  def display_create_another_one # rubocop:disable Naming/PredicateMethod
    action_name.in?(CREATE_ANOTHER_ONE_ACTIONS)
  end

  def boolean_to_badge_component(boolean)
    color = boolean ? :success : :danger
    icon = "bi-#{boolean ? "check" : "x"}"
    text = I18n.t("boolean.#{boolean}")

    BadgeComponent.new(color:, variant: :pill).with_content(
      tag.span(class: "d-inline-flex align-items-center") do
        concat(tag.span(class: "bi #{icon}-circle-fill text-#{color} me-2"))
        concat(tag.span(text))
      end,
    )
  end

  def value_or_nc(value)
    return tag.span(I18n.t("n_a"), class: "fst-italic fw-light text-body-secondary") if value.blank?

    value
  end
end
