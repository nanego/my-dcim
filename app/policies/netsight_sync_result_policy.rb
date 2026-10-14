# frozen_string_literal: true

class NetsightSyncResultPolicy < ApplicationPolicy
  pre_check :deny_readers

  def sync?
    manage?
  end

  def apply?
    manage?
  end
end
