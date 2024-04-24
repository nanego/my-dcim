# frozen_string_literal: true

class ChangelogEntryDecorator < ApplicationDecorator
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

  def object_changed_attributes_to_sentence
    object_changed_attributes.keys.map do |attribute|
      object_klass&.human_attribute_name(attribute) || attribute.titleize
    end.to_sentence
  end

  def action_label_to_component
    types = {
      create: :success,
      update: :primary,
      destroy: :danger
    }

    LabelComponent.new(action, type: types[action.to_sym] || :default)
  end
end
