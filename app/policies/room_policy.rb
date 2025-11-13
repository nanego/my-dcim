# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.all_domains?

    relation.where(islets: authorized_scope(Islet.all))
  end

  def show?
    return index? if user.all_domains?

    record.islets.intersect?(authorized_scope(Islet.all))
  end
end
