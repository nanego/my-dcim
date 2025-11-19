# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    relation.where(islets: authorized_scope(Islet.all))
  end
end
