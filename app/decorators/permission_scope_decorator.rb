# frozen_string_literal: true

class PermissionScopeDecorator < ApplicationDecorator
  class << self
    def roles_options_for_select
      PermissionScope.roles.keys.map { |role| [PermissionScope.human_attribute_name("role.#{role}"), role] }
    end
  end
end
