# frozen_string_literal: true

class SitePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    # TODO: call frame policy scope directly?
    relation.where(room: Room.where(islet:
        Islet.where(bay:
          Bay.where(frame:
            Frame.where(
              server: Server.where(domaine: user.permitted_domains)
            )
          )
        )
      )
    )
  end
end
