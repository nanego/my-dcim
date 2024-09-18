# frozen_string_literal: true

class ObjectChangelogComponent < ApplicationComponent
  def initialize(object, **options)
    @object = object
    @html_options = options

    super()
  end

  def call
    helpers.turbo_frame_tag "changelog-entries", loading: :lazy, src: object_changelog_path, **@html_options do
      tag.div class: "w-100 d-flex justify-content-center align-items-center gap-3" do
        concat(t(".loading"))
        concat(tag.span(class: "spinner-border spinner-border-sm p-4"))
      end
    end
  end

  private

  def object_changelog_path
    object_changelog_entries_path(@object.model_name.plural, @object.id)
  end
end
