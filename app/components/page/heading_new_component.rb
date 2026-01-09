# frozen_string_literal: true

module Page
  class HeadingNewComponent < ApplicationComponent
    def initialize(resource:, title:, breadcrumb:, back_button_url: nil)
      @resource = resource
      @title = title
      @breadcrumb = breadcrumb
      @back_button_url = back_button_url

      super()
    end

    def call
      render HeadingComponent.new(title: @title, breadcrumb: @breadcrumb, back_button_url:)
    end

    private

    def back_button_url
      @back_button_url.presence || polymorphic_path(@resource.class)
    end
  end
end
