# frozen_string_literal: true

module Form
  class ActionsComponent < ApplicationComponent
    def initialize(form)
      @form = form
      @is_edit = form.object.persisted?
      @is_new = !@is_edit

      super
    end

    def call
      cancel_url = @is_edit ? @form.object : polymorphic_path(@form.object.class)

      tag.div class: "col-12 py-4 mt-4 text-end sticky-bottom bg-body-tertiary border-top" do
        concat(link_to(t("action.cancel"), cancel_url, class: "btn btn-outline-secondary me-2"))
        concat(@form.submit(class: class_names("btn", "btn-info": @is_edit, "btn-success": @is_new)))
      end
    end
  end
end
