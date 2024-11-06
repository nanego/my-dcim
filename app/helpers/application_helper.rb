# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def accepted_format_for_attachment(model_klass, attribute_name)
    validator = model_klass.validators_on(attribute_name.to_sym).find do |v|
      v.is_a?(ActiveStorageValidations::ContentTypeValidator)
    end

    return unless validator

    validator.options[:in].map { |f| Mime[f].to_s }.uniq.join(", ")
  end

  def surface_area_with_suffix(surface_area)
    "#{surface_area} #{t("surface_area.unit")}"
  end
end
