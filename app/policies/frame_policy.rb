# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.writer?

    relation.where(servers: authorized_scope(Server.all))
  end

  def show?
    return index? if user.writer?

    record.servers.intersect?(authorized_scope(Server.all))
  end

  def sort?
    manage?
  end

  def network?
    index?
  end
end
