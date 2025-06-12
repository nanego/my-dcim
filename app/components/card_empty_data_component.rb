# frozen_string_literal: true

class CardEmptyDataComponent < ApplicationComponent
  def initialize(icon: :table, **_options)
    @icon = icon

    super()
  end

  def call
    render CardComponent.new(extra_classes: "text-center text-secondary-emphasis") do
      concat(tag.span(class: "bi bi-#{@icon} fs-1 text-secondary text-opacity-25"))
      concat(tag.h5(t(".title"), class: "card-title mt-3"))
    end
  end
end
