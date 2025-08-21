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
      tag.span(class: "create-delete-button-component") do
        concat(
          link_to bay_path(@bay_id),
                  method: :delete,
                  class: "link-danger",
                  title: t(".delete_button.title"),
                  aria: { hidden: true },
                  data: {
                    confirm: t(".delete_button.confirm"),
                    controller: "tooltip",
                    bs_placement: "bottom"
                  } do
            tag.span(class: "bi bi-dash-circle-fill")
          end
        )
        concat(
          link_to new_frame_path(frame: { bay_id: @bay_id, position: @position }),
                  class: "link-success",
                  title: t(".create_button.title"),
                  aria: { hidden: true },
                  data: {
                    controller: "tooltip",
                    bs_placement: "bottom"
                  } do
            tag.span(class: "bi bi-plus-circle-fill")
          end
        )
      end
    end
  end
end
