# frozen_string_literal: true

module Overview
  class CreateDeleteButtonComponent < ApplicationComponent
    def initialize(bay_id, position, **html_options)
      @bay_id = bay_id
      @position = position
      @html_options = html_options

      super
    end

    def call
      tag.span(class: "bay d-flex bg-body-tertiary border-secondary-subtle border py-2 align-items-center") do
        concat(link_to new_frame_path do
          tag.span(class: "bi bi-plus-circle-fill")
        end)
        concat(link_to bay_path(@bay_id), method: :delete do
          tag.span(class: "bi bi-dash-circle-fill")
        end)
      end
    end
  end
end
