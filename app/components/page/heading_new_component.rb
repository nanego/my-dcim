# frozen_string_literal: true

module Page
  class HeadingNewComponent < ApplicationComponent
    def initialize(resource:, title:, breadcrumb_steps:)
      @resource = resource
      @title = title
      @breadcrumb_steps = breadcrumb_steps

      super
    end

    def call
      render HeadingComponent.new(
        title: @title, breadcrumb_steps: @breadcrumb_steps, back_button_url: polymorphic_path(@resource.class)
      )
    end
  end
end
