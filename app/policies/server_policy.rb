# frozen_string_literal: true

class ServerPolicy < ApplicationPolicy
  relation_scope do |relation|
    relation = relation.no_pdus

    return relation if user.admin? || user.writer?

    relation.where(domaine: user.permitted_domains)
  end

  def show?
    user.permitted_domains.include?(record.domaine)
  end

  def duplicate?
    manage?
  end

  def sort?
    user.writer?
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
end
