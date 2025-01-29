# frozen_string_literal: true

class ChangelogEntry < ApplicationRecord
  belongs_to :object, polymorphic: true, optional: true
  belongs_to :author, polymorphic: true, optional: true, default: -> { ChangelogContext.author }

  validates :object_type, presence: true
  validates :object_id, presence: true

  def object_display_name
    "#{object_type_name}: #{object_name || "##{object_id}"}"
  end

  def object_type_name
    return if object_type.blank?

    object_type.safe_constantize&.model_name&.human || object_type
  end

  def object_name
    object.try(:name).presence || object.try(:display_name).presence || "##{object_id}"
  end

  def object_klass
    object_type.safe_constantize
  end

  def author_display_name
    return unless author_type

    author || "##{author_id}"
  end

  def author_type_name
    return if author_type.blank?

    author_type.safe_constantize&.model_name&.human || author_type
  end
end
