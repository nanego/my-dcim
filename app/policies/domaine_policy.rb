# frozen_string_literal: true

class DomainePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    user.permitted_domains
  end
end
