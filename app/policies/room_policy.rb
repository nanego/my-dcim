# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where(islets: authorized_scope(Islet.all))
  end

  def show?
    return index? if user.can_access_all_domains?

    record.islets.intersect?(authorized_scope(Islet.all))
  end
end
