# frozen_string_literal: true

module Changelogable
  extend ActiveSupport::Concern

  CHANGELOGABLE_DEFAULT_SKIP_ATTRIBUTES = %i[id created_at updated_at].freeze

  module ClassMethods
    attr_accessor :_changelogable_except_attributes, :_changelogable_association_names

    def has_changelog(except: [], associations: {})
      @_changelogable_except_attributes = CHANGELOGABLE_DEFAULT_SKIP_ATTRIBUTES.dup.append(*except)
      @_changelogable_association_names = associations

      has_many :changelog_entries, -> { order(created_at: :desc) }, as: :object, dependent: nil,
                                                                    inverse_of: :object

      before_save :store_associations_attributes
      after_create_commit :changelog_entry_on_create
      after_update_commit :changelog_entry_on_update
      before_destroy :changelog_entry_on_destroy
    end

    # TODO: for the associations
    #
    # Idea 1:
    #   - store _ids
    #
    # Idea 2:
    #   - store object_changes
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

  def store_associations_attributes
    @store_associations_attributes ||= associations_attributes
  end

  def _create_changelog_entry(action, object_changes: _changeloagable_previous_changes, metadata: {})
    changelog_entries.create!(
      action: action,
      object_changed_attributes: object_changes,
      metadata: ChangelogContext.metadata.to_h.merge(metadata),
    )
  end

  def _changeloagable_previous_changes
    changes = previous_changes

    # changes[:associations] = @_changelogable_assocations_attributes_before_save

    _changelogable_parameter_filter(changes)
  end

  def associations_attributes
    # pour du has_many through ça va pas car ça va être les ids qui nous intéresse et surement load le display_name pour stocker
    self.class._changelogable_association_names.index_with do |association_name|
      public_send(association_name).map(&:attributes)
    end
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
