# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    # TODO: call frame policy scope directly?
    relation.where(islet:
      Islet.where(bay:
        Bay.where(frame:
          Frame.where(
            server: Server.where(domaine: user.permitted_domains)
          )
        )
      )
    )
  end

  def overview?
    index?
  end
end
