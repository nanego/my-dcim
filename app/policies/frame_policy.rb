# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where(servers: authorized_scope(Server.all))
  end

  def show?
    return index? if user.can_access_all_domains?

    record.servers.intersect?(authorized_scope(Server.all))
  end

  def sort?
    manage?
  end
end
