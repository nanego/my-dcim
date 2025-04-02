# frozen_string_literal: true

module Page
  class HeadingNewComponent < ApplicationComponent
    def initialize(resource:, title:, breadcrumb:)
      @resource = resource
      @title = title
      @breadcrumb = breadcrumb

      super
    end

    def call
      render HeadingComponent.new(
        title: @title, breadcrumb: @breadcrumb, back_button_url: polymorphic_path(@resource.class)
      )
    end
  end
end
