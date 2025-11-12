# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.writer?

    relation.where(rooms: authorized_scope(Room.all))
  end

  def show?
    record.rooms.intersect?(authorized_scope(Room.all))
  end
end
