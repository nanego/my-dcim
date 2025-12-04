# frozen_string_literal: true

class SearchResultPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin? || user.can_access_all_domains?

    relation.where("domaine_ids && array[?]", user.permitted_domains.ids)
  end

  def index?
    true
  end
end
