# frozen_string_literal: true

class ChangelogEntry < ApplicationRecord
  belongs_to :object, polymorphic: true
  belongs_to :author, polymorphic: true, optional: true, default: -> { ChangelogContext.author }

  def object_display_name
    "#{object_type_name}: #{object_name || "##{object_id}"}"
  end

  def object_type_name
    object_type&.safe_constantize&.model_name&.human || object_type
  end

  def object_name
    object.try(:name).presence || object.try(:display_name).presence || "##{object_id}"
  end

  def author_display_name
    return unless author_type

    author || "##{author_id}"
  end

  def author_type_name
    author_type&.safe_constantize&.model_name&.human || author_type
  end

  def object_pre_change_attributes
    object_changed_attributes.transform_values { |v| v[0] }
  end

  def object_pre_change_attributes_to_json
    JSON.pretty_generate(object_pre_change_attributes)
  end

  def object_post_change_attributes
    object_changed_attributes.transform_values { |v| v[1] }
  end

  def object_post_change_attributes_to_json
    JSON.pretty_generate(object_post_change_attributes)
  end

  def split_diff
    Diffy::SplitDiff.new(object_pre_change_attributes_to_json, object_post_change_attributes_to_json, format: :html)
  end

  def action_label_to_component
    types = {
      create: :success,
      update: :warning,
      destroy: :danger,
    }

    LabelComponent.new(action, type: types[action.to_sym] || :default)
  end
end
