# frozen_string_literal: true

class BayPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    # TODO: call frame policy scope directly?
    relation.where(frame:
      Frame.where(
        server: Server.where(domaine: user.permitted_domains)
      )
    )
  end

  def print?
    index?
  end
end
