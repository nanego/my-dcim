# frozen_string_literal: true

class PermissionScopePolicy < ApplicationPolicy
  def index?
    false
  end

  def create?
    false
  end

  def manage?
    false
  end
end
