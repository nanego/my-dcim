# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where(frames: authorized_scope(Frame.all))
  end

  def show?
    return index? if user.can_access_all_domains?

    record.frames.intersect?(authorized_scope(Frame.all))
  end
end
