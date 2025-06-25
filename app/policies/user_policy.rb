# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def edit_user?
    user.admin?
  end

  def update_user?
    user.admin?
  end
end
