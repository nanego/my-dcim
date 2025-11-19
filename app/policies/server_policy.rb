# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  relation_scope do |relation|
    relation = relation.no_pdus

    return relation if user.admin? || user.can_access_all_domains?

    relation.where(domaine: user.permitted_domains)
  end

  def show?
    return index? if user.can_access_all_domains?

    user.permitted_domains.include?(record.domaine)
  end

  def duplicate?
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
    manage?
  end

  def export_cables?
    export?
  end
end
