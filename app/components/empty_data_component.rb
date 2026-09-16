# frozen_string_literal: true

class EmptyDataComponent < ApplicationComponent
  def initialize(icon: :slash_circle, text: nil)
    @icon = icon.to_s.dasherize
    @text = text.presence || I18n.t("empty_data_component.title")

    super()
  end

  def call
    tag.div(class: "text-center text-secondary-emphasis") do
      concat(tag.span(class: "bi bi-#{@icon} fs-1 text-secondary text-opacity-25"))

      if content?
        concat(tag.div(class: "card-title mt-3") { content })
      elsif @text.present?
        concat(tag.h5(@text, class: "card-title mt-3"))
      end
    end
  end
end
