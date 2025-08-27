# frozen_string_literal: true

class ChangelogEntryPolicy < ApplicationPolicy
  def index?
    manage?
  end
end
