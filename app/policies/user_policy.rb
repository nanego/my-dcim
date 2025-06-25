# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end
end
