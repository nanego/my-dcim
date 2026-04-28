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

  def color_representation_of(value)
    lighten_color("##{Digest::MD5.hexdigest(value || "test")[0..5]}", 0.4)
  end

  def lighten_color(hex_color, amount = 0.6)
    hex_color = hex_color.delete("#")
    rgb = hex_color.scan(/../).map(&:hex)
    rgb[0] = [(rgb[0].to_i + (255 * amount)).round, 255].min
    rgb[1] = [(rgb[1].to_i + (255 * amount)).round, 255].min
    rgb[2] = [(rgb[2].to_i + (255 * amount)).round, 255].min

    format("#%02x%02x%02x", *rgb)
  end
end
