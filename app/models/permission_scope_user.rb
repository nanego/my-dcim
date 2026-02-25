# frozen_string_literal: true

class PermissionScopeUser < ApplicationRecord
  belongs_to :permission_scope, touch: true
  belongs_to :user
end
