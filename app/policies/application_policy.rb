# frozen_string_literal: true

class ApplicationPolicy < ActionPolicy::Base
  pre_check :allow_admins

  alias_rule :show?, to: :index?

  def index?
    true
  end

  def create?
    user.writer?
  end

  def manage?
    user.writer?
  end

  private

  def allow_admins
    allow! if user.admin?
  end
end
