# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  skip_pre_check :allow_admins

  def index?
    user.admin?
  end

  def show?
    user.admin? || user == record
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin? && user != record
  end

  def manage?
    user.admin?
  end

  def add_user?
    manage?
  end

  def suspend?
    user.admin? && user != record
  end

  def unsuspend?
    suspend?
  end
end
