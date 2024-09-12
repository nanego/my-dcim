# frozen_string_literal: true

module ChangelogEntriesHelper
  def object_changelog_entries(object, **)
    tag.turbo_frame(id: "changelog-entries", loading: :lazy, src: object_changelog_entries_path(object), **)
  end

  private

  def object_changelog_entries_path(object)
    "/#{object.class.name.underscore.pluralize}/#{object.id}/changelog_entries"
  end
end
