# frozen_string_literal: true

class IsletPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    relation.where(bays: authorized_scope(Bay.all))
  end

  def print?
    index?
  end
end
