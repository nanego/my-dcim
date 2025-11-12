# frozen_string_literal: true

class PermissionScopeUserDecorator < ApplicationDecorator
  class << self
    def users_options_for_select(permission_scope)
      User.select(:email, :name, :id, :suspended_at)
        .ordered
        .where.not(id: permission_scope.users)
        .map do |user|
          options = {}
          name = user.to_s

          if user.suspended?
            name << " (#{User.human_attribute_name("state.suspended")})"
            options[:disabled] = :disabled
          end

          [name, user.id, options]
        end
    end
  end
end
