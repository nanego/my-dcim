# frozen_string_literal: true

class DomainPolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?

    user.permitted_domains
  end
end
