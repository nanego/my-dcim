# frozen_string_literal: true

module ChangelogEntriesHelper
  def object_changelog_entries(object, **)
    turbo_frame_tag "changelog-entries", loading: :lazy, src: object_changelog_path(object), ** do
      tag.div class: "w-100 d-flex justify-content-center align-items-center gap-3" do
        concat("Loading changelog...")
        concat(tag.span(class: "spinner-border spinner-border-sm p-4"))
      end
    end
  end

  private

  def object_changelog_path(object)
    object_changelog_entries_path(object.model_name.plural, object.id)
  end
end
