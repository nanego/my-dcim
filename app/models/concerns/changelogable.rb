# frozen_string_literal: true

module Changelogable
  extend ActiveSupport::Concern

  CHANGELOGABLE_DEFAULT_SKIP_ATTRIBUTES = %i[id created_at updated_at].freeze

  module ClassMethods
    attr_accessor :_changelogable_except_attributes

    def has_changelog(except: []) # rubocop:disable Naming/PredicateName
      @_changelogable_except_attributes = CHANGELOGABLE_DEFAULT_SKIP_ATTRIBUTES.dup.append(*except)

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
    changes = _changeloagable_previous_changes

    return if changes.empty?

    _create_changelog_entry(:update, object_changes: changes)
  end

  def changelog_entry_on_destroy
    _create_changelog_entry(:destroy, object_changes: _changelogable_parameter_filter(attributes.transform_values { |v| [v, nil] }))
  end

  private

  def _create_changelog_entry(action, object_changes: _changeloagable_previous_changes, metadata: {})
    changelog_entries.create!(
      action: action,
      object_changed_attributes: object_changes,
      metadata: ChangelogContext.metadata.to_h.merge(metadata)
    )
  end

  def _changeloagable_previous_changes
    _changelogable_parameter_filter(previous_changes)
  end

  def _changelogable_parameter_filter(changes)
    changes.symbolize_keys
      .except(*self.class._changelogable_except_attributes)
      .to_h do |key, (before, after)|
      [
        key,
        [parameter_filter.filter_param(key, before), parameter_filter.filter_param(key, after)],
      ]
    end
  end

  def parameter_filter
    @parameter_filter ||= ActiveSupport::ParameterFilter.new(Rails.application.env_config["action_dispatch.parameter_filter"])
  end
end
