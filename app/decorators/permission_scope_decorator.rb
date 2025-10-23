# frozen_string_literal: true

class PermissionScopeDecorator < ApplicationDecorator
  class << self
    def roles_options_for_select
      PermissionScope.roles.keys.map { |role| [PermissionScope.human_attribute_name("role.#{role}"), role] }
    end

    def users_options_for_select
      User.select(:email, :name, :id)
        .map { |user| [user.to_s, user.id] }
    end
  end
end
