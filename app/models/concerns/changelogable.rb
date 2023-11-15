# frozen_string_literal: true

module Changelogable
  extend ActiveSupport::Concern

  module ClassMethods
    def has_changelog # rubocop:disable Naming/PredicateName
      has_many :changelog_entries, -> { order(created_at: :desc) }, as: :object

      after_create_commit :changelog_entry_on_create
      after_update_commit :changelog_entry_on_update
      before_destroy :changelog_entry_on_destroy
    end
  end

  def changelog_entry_on_create
    _create_changelog_entry(:create)
  end

  def changelog_entry_on_update
    return if previous_changes.empty?

    _create_changelog_entry(:update)
  end

  def changelog_entry_on_destroy
    _create_changelog_entry(:destroy, object_changes: attributes.to_h { |k, v| [k, [v, nil]] })
  end

  def _create_changelog_entry(action, object_changes: previous_changes, metadata: {})
    changelog_entries.create!(
      action: action,
      object_changed_attributes: object_changes,
      metadata: ChangelogContext.metadata.to_h.merge(metadata)
    )
  end
end
