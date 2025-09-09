# frozen_string_literal: true

class ChangelogEntryPolicy < ApplicationPolicy
  authorize :scoped_object, optional: true

  def index?
    return allowed_to?(:show?, scoped_object) if scoped_object.present?

    manage?
  end
end
