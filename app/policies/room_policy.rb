# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.writer?

    relation.where(islets: authorized_scope(Islet.all))
  end

  def show?
    return index? if user.writer?

    record.islets.intersect?(authorized_scope(Islet.all))
  end
end
