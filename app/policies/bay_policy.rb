# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    relation.where(frames: authorized_scope(Frame.all))
  end

  def print?
    index?
  end
end
