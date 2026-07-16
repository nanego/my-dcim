# frozen_string_literal: true

class CardEmptyDataComponent < ApplicationComponent
  def initialize(icon: :slash_circle, text: I18n.t("card_empty_data_component.title"), **_options)
    @icon = icon.to_s.dasherize
    @text = text

    super()
  end

  def call
    render CardComponent.new(extra_classes: "text-center text-secondary-emphasis") do
      concat(tag.span(class: "bi bi-#{@icon} fs-1 text-secondary text-opacity-25"))

      if content.present?
        concat(tag.div(class: "card-title mt-3") { content })
      elsif @text.present?
        concat(tag.h5(@text, class: "card-title mt-3"))
      end
    end
  end
end
