# frozen_string_literal: true

module ChangelogEntriesHelper
  def object_changelog_entries_path(object)
    "/#{object.class.name.underscore.pluralize}/#{object.id}/changelog_entries"
  end
end
