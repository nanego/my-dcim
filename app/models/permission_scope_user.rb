# frozen_string_literal: true

class PermissionScopeUser < ApplicationRecord
  has_changelog associated_to: %i[permission_scope user]

  belongs_to :permission_scope, touch: true
  belongs_to :user, touch: true
end
