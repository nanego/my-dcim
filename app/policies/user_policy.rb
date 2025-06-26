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

  def manage?
    user.admin?
  end
end
