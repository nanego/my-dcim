# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
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
end
