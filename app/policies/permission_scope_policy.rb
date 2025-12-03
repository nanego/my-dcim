# frozen_string_literal: true

class PermissionScopePolicy < ApplicationPolicy
  skip_pre_check :allow_admins, only: :destroy?

  def index?
    false
  end

  def create?
    false
  end

  def manage?
    false
  end

  def destroy?
    user.admin? && !record.is_system
  end
end
