# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    relation.where(servers: authorized_scope(Server.all))
  end

  def sort?
    manage?
  end

  def network?
    index?
  end
end
