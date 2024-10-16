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
      render HeadingComponent.new(title: @title, breadcrumb_steps: @breadcrumb_steps) do |heading|
        heading.with_left_content do
          tag.span class: "flex-grow-1" do
            render ButtonComponent.new(title: t("action.back"),
                                       url: polymorphic_url(@resource.class),
                                       icon: "chevron-left",
                                       is_responsive: true)
          end
        end

        heading.with_right_content do
          tag.span class: "flex-grow-1"
        end
      end
    end
  end
end
