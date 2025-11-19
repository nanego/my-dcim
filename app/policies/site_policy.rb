# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    relation.where(rooms: authorized_scope(Room.all))
  end
end
