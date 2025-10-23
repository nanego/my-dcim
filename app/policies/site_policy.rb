# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    relation.where(rooms: authorized_scope(Room.all))
  end
end
