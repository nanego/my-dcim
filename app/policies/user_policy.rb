# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin?
  end

  def new?
    user.admin?
  end

  def add_user?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def reset_authentication_token?
    user.admin?
  end

  def suspend?
    user.admin?
  end

  def unsuspend?
    user.admin?
  end
end
