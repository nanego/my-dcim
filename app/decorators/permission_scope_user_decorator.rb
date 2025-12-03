# frozen_string_literal: true

class PermissionScopeUserDecorator < ApplicationDecorator
  class << self
    def users_options_for_select(permission_scope)
      User.select(:email, :name, :id, :suspended_at)
        .ordered
        .unsuspended
        .where.not(id: permission_scope.users)
        .map do |user|
          options = {}
          name = user.to_s

          [name, user.id, options]
        end
    end
  end
end
