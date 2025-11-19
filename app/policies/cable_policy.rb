# frozen_string_literal: true

class CablePolicy < ApplicationPolicy
  relation_scope do |relation|
    return relation if user.admin?
    return relation if user.reader_of_all_domains?

    relation.joins(:servers).where(servers: authorized_scope(Server.all))
  end
end
