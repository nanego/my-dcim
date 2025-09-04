# frozen_string_literal: true

class ChangelogEntryPolicy < ApplicationPolicy
  authorize :scoped_object, optional: true

  def index?
    return true if scoped_object.present?

    manage?
  end
end
