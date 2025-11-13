# frozen_string_literal: true

class IsletPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.all_domains?

    relation.where(bays: authorized_scope(Bay.all))
  end

  def show?
    return index? if user.all_domains?

    record.bays.intersect?(authorized_scope(Bay.all))
  end

  def print?
    index?
  end
end
