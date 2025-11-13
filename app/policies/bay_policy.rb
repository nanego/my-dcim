# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.all_domains?

    relation.where(frames: authorized_scope(Frame.all))
  end

  def show?
    return index? if user.all_domains?

    record.frames.intersect?(authorized_scope(Frame.all))
  end
end
