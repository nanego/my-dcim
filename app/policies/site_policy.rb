# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where(rooms: authorized_scope(Room.all))
  end

  def show?
    return index? if user.can_access_all_domains?

    record.rooms.intersect?(authorized_scope(Room.all))
  end
end
