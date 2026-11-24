# frozen_string_literal: true

class PowerDistributionUnitPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where(frame: authorized_scope(Frame.all))
  end

  def duplicate?
    manage?
  end
end
