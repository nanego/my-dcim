# frozen_string_literal: true

class FramePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    # TODO: call frame policy scope directly?
    relation.where(server: Server.where(domaine: user.permitted_domains))
  end

  def sort?
    manage?
  end

  def network?
    index?
  end
end
