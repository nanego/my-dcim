# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  relation_scope do |relation|
    relation = relation.no_pdus

    return relation if user.admin?

    relation.where(domaine: user.permitted_domains)
  end

  def duplicate?
    manage?
  end

  def destroy_connections?
    manage?
  end

  def sort?
    manage?
  end

  def import?
    manage?
  end

  def import_csv?
    manage?
  end

  def export?
    index?
  end
end
