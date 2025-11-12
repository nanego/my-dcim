# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.writer?

    relation.where(frames: authorized_scope(Frame.all))
  end

  def show?
    record.frames.intersect?(authorized_scope(Frame.all))
  end
end
