# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    relation.where(servers: authorized_scope(Server.all))
  end

  def sort?
    manage?
  end

  def network?
    index?
  end
end
