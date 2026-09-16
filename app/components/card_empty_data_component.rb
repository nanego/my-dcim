# frozen_string_literal: true

class CardEmptyDataComponent < ApplicationComponent
  def initialize(icon: :slash_circle, text: nil, **options)
    @icon = icon
    @text = text
    @options = options

    super()
  end

  def call
    render CardComponent.new do
      render EmptyDataComponent.new(icon: @icon, text: @text, **@options)
    end
  end
end
