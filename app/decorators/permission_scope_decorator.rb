# frozen_string_literal: true

class PermissionScopeDecorator < ApplicationDecorator
  class << self
    def roles_for_options
      PermissionScope.roles.keys.map { |role| [PermissionScope.human_attribute_name("role.#{role}"), role] }
    end

    def users_for_options
      User.select(:email, :name, :id)
          .map { |user| [user.to_s, user.id] }
    end
  end
end
