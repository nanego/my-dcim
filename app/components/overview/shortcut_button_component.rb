# frozen_string_literal: true

module Overview
  class ShortcutButtonComponent < ApplicationComponent
    def initialize(id, position, redirection, lane = nil, **html_options)
      @id = id
      @position = position
      @redirection = redirection
      @lane = lane

      @html_options = html_options

      super
    end

    def call
      render button_klass.new(@id, @position, @redirection, @lane, **@html_options)
    end

    private

    def button_klass
      @lane.present? ? CreateBayButtonComponent : CreateFrameDeleteBayButtonComponent
    end
  end

  class CreateFrameDeleteBayButtonComponent < ShortcutButtonComponent
    def call
      tag.span(class: "shortcut-button-component") do
        concat(
          link_to(bay_path(@id, params: { redirect_to_on_success: :back }),
                  method: :delete,
                  class: "link-danger",
                  title: t(".delete_frame.title"),
                  aria: { hidden: true },
                  data: {
                    confirm: t(".delete_frame.confirm"),
                    controller: "tooltip",
                    bs_placement: "bottom",
                  }) do
            tag.span(class: "bi bi-dash-circle-fill")
          end,
        )
        concat(
          link_to(new_frame_path(frame: { bay_id: @id, position: @position }, redirect_to_on_success: @redirection),
                  class: "link-success",
                  title: t(".create_frame.title"),
                  aria: { hidden: true },
                  data: {
                    controller: "tooltip",
                    bs_placement: "bottom",
                  }) do
            tag.span(class: "bi bi-plus-circle-fill")
          end,
        )
      end
    end
  end

  class CreateBayButtonComponent < ShortcutButtonComponent
    def call
      tag.span(class: "shortcut-button-component") do
        link_to new_bay_path(bay: { islet_id: @id, position: @position, lane: @lane },
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
