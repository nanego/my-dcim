# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    relation.where(islets: authorized_scope(Islet.all))
  end

  def overview?
    index?
  end
end
