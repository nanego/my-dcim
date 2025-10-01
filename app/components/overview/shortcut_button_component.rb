# frozen_string_literal: true

module Overview
  class ShortcutButtonComponent < ApplicationComponent
    def initialize(id, position, redirection, lane = nil, **html_options)
      @button = if lane.present?
                  CreateBayButtonComponent.new(id, position, lane, redirection, **html_options)
                else
                  CreateFrameDeleteBayButtonComponent.new(id, position, redirection, **html_options)
                end

      super
    end

    def call
      render @button
    end
  end

  class CreateFrameDeleteBayButtonComponent < ShortcutButtonComponent
    def initialize(bay_id, position, redirection, **html_options) # rubocop:disable Lint/MissingSuper
      @bay_id = bay_id
      @position = position
      @redirection = redirection
      @html_options = html_options
    end

    def call
      tag.span(class: "shortcut-button-component") do
        concat(
          link_to bay_path(@bay_id, params: { redirect_to_on_success: :back }),
                  method: :delete,
                  class: "link-danger",
                  title: t(".delete_frame.title"),
                  aria: { hidden: true },
                  data: {
                    confirm: t(".delete_frame.confirm"),
                    controller: "tooltip",
                    bs_placement: "bottom",
                  } do
            tag.span(class: "bi bi-dash-circle-fill")
          end,
        )
        concat(
          link_to new_frame_path(frame: { bay_id: @bay_id, position: @position }, redirect_to_on_success: @redirection),
                  class: "link-success",
                  title: t(".create_frame.title"),
                  aria: { hidden: true },
                  data: {
                    controller: "tooltip",
                    bs_placement: "bottom",
                  } do
            tag.span(class: "bi bi-plus-circle-fill")
          end,
        )
      end
    end
  end

  class CreateBayButtonComponent < ShortcutButtonComponent
    def initialize(islet_id, position, lane, redirection, **html_options) # rubocop:disable Lint/MissingSuper
      @islet_id = islet_id
      @position = position
      @lane = lane
      @redirection = redirection
      @html_options = html_options
    end

    def call
      tag.span(class: "shortcut-button-component") do
        link_to new_bay_path(bay: { islet_id: @islet_id, position: @position, lane: @lane },
                             redirect_to_on_success: @redirection),
                class: "link-success",
                title: t(".create_bay.title"),
                aria: { hidden: true },
                data: {
                  controller: "tooltip",
                  bs_placement: "bottom",
                } do
          tag.span(class: "bi bi-plus-circle-fill")
        end
      end
    end
  end
end
