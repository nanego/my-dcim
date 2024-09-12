# frozen_string_literal: true

module ChangelogEntriesHelper
  def object_changelog_entries(object, **)
    turbo_frame_tag "changelog-entries", loading: :lazy, src: object_changelog_entries_path(model_name(object), object.id), ** do
      tag.div class: "d-flex justify-content-center w-100" do
        tag.span class: "spinner-border spinner-border-sm p-4"
      end
    end
  end

  private

  def model_name(object)
    object.model_name.plural
  end
end
