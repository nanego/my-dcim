# frozen_string_literal: true

class PowerDistributionUnitPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    relation.where(domaine: user.permitted_domains)
  end

  def duplicate?
    manage?
  end

  def destroy_connections?
    manage?
  end
end
