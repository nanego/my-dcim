# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def show?
    user.admin? || user == record
  end

  def new?
    user.admin?
  end

  def destroy?
    user.admin? && user != record
  end

  def manage?
    user.admin?
  end

  def suspend?
    user.admin? && user != record
  end

  def unsuspend?
    suspend?
  end
end
