# frozen_string_literal: true

class ChangelogEntry < ApplicationRecord
  belongs_to :object, polymorphic: true
  belongs_to :author, polymorphic: true, optional: true, default: -> { ChangelogContext.author }

  def object_display_name
    "#{object.model_name.human}: #{object}"
  end
end
