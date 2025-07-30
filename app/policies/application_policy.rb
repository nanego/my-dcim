# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  pre_check :allow_admins

  def new?
    user.writer?
  end

  def destroy?
    user.writer?
  end

  def edit?
    user.writer?
  end

  def show?
    user.reader? || user.writer?
  end

  private

  def allow_admins
    allow! if user.admin?
  end
end
