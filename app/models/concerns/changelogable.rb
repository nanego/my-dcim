module Changelogable
  extend ActiveSupport::Concern

  module ClassMethods
    def log_changes()
      has_many :changelog_entries, as: :object

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
    _create_changelog_entry(:destroy)
  end

  private

  def _create_changelog_entry(action, metadata: {})
    changelog_entries.create!(
      action: action,
      author: ChangelogContext.author,
      object_changes: previous_changes,
      metadata: ChangelogContext.metadata.to_h.merge(metadata),
    )
  # rescue => e
  #   binding.irb
  end
end
