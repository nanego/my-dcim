# frozen_string_literal: true

class ChangelogEntryDecorator < ApplicationDecorator
  class << self
    def authors_options
      User.select(:id, :name, :email).map { |u| [u.id, u.to_s] }
    end

    def object_types_options
      ChangelogEntry.distinct.pluck(:object_type).map do |type|
        model = type.safe_constantize

        [model.model_name.human, model.name]
      end
    end
  end

  def object_link_to(view_context, **html_attributes)
    return object_display_name unless object.object

    view_context.link_to object_display_name, object.object, **html_attributes
  rescue NoMethodError
    object_display_name
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

  def object_changed_attributes_to_sentence
    object_changed_attributes.keys.map do |attribute|
      object_klass&.human_attribute_name(attribute) || attribute.titleize
    end.to_sentence
  end

  def action_to_badge_component
    colors = {
      create: :success,
      update: :info,
      destroy: :danger
    }

    BadgeComponent.new(action, color: colors[action.to_sym] || :primary)
  end
end
