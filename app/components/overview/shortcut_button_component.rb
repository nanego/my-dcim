# frozen_string_literal: true

module Overview
  class ShortcutButtonComponent < ApplicationComponent
    def initialize(id, position, lane = nil, **html_options)
      super

      if lane.present?
        @button = CreateBayButtonComponent.new(id, position, lane, **html_options)
      else
        @button = CreateFrameDeleteBayButtonComponent.new(id, position, **html_options)
      end
    end

    def call
      render @button
    end
  end

  private

  class CreateFrameDeleteBayButtonComponent < ShortcutButtonComponent
    def initialize(bay_id, position, **html_options)
      @bay_id = bay_id
      @position = position
      @html_options = html_options
    end

    def call
      tag.span(class: "shortcut-button-component") do
        concat(
          link_to bay_path(@bay_id, params: { redirect_to_on_success: :back } ),
                  method: :delete,
                  class: "link-danger",
                  title: t(".delete_frame.title"),
                  aria: { hidden: true },
                  data: {
                    confirm: t(".delete_frame.confirm"),
                    controller: "tooltip",
                    bs_placement: "bottom"
                  } do
            tag.span(class: "bi bi-dash-circle-fill")
          end
        )
        concat(
          link_to new_frame_path(frame: { bay_id: @bay_id, position: @position }, redirect_to_on_success: 1),
                  class: "link-success",
                  title: t(".create_frame.title"),
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

  class CreateBayButtonComponent < ShortcutButtonComponent
    def initialize(islet_id, position, lane, **html_options)
      @islet_id = islet_id
      @position = position
      @lane = lane
      @html_options = html_options
    end

    def call
      tag.span(class: "shortcut-button-component") do
        link_to new_bay_path(bay: { islet_id: @islet_id, position: @position, lane: @lane }, redirect_to_on_success: 1),
                class: "link-success",
                title: t(".create_bay.title"),
                aria: { hidden: true },
                data: {
                  controller: "tooltip",
                  bs_placement: "bottom"
                } do
          tag.span(class: "bi bi-plus-circle-fill")
        end
      end
    end
  end
end
