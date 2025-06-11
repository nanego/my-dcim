# frozen_string_literal: true

module Form
  class ActionsComponent < ApplicationComponent
    def initialize(form, display_create_another_one: false)
      @form = form
      @is_edit = form.object.persisted?
      @is_new = !@is_edit
      @display_create_another_one = display_create_another_one

      super
    end

    def call
      cancel_url = @is_edit ? @form.object : polymorphic_path(@form.object.class)

      tag.div class: "col-12 py-4 mt-4 text-end sticky-bottom bg-body-tertiary border-top" do
        tag.span class: "d-inline-flex align-items-center me-auto" do
          concat(render_another_one_checkbox) if @display_create_another_one
          concat(link_to(t("action.cancel"), cancel_url, class: "btn btn-outline-secondary me-2"))
          concat(@form.submit(class: class_names("btn", "btn-info": @is_edit, "btn-success": @is_new)))
        end
      end
    end

    private

    def render_another_one_checkbox
      checked = params[:create_another_one] == "1"

      tag.span(class: "me-3 form-check form-check-inline") do
        concat(check_box_tag(:create_another_one, "1", checked, class: "form-check-input"))
        concat(label_tag(:create_another_one, t("action.create_more"), class: "form-check-label"))
      end
    end
  end
end
