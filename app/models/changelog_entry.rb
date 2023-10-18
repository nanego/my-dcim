# frozen_string_literal: true

class ChangelogEntry < ApplicationRecord
  belongs_to :object, polymorphic: true
  belongs_to :author, polymorphic: true, optional: true, default: -> { ChangelogContext.author }

  def object_display_name
    "#{object_type_name}: #{object || object_id}"
  end

  def object_type_name
    object_type.safe_constantize&.model_name&.human || object_type
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
