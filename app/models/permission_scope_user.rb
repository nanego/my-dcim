# frozen_string_literal: true

class PermissionScopeUser < ApplicationRecord
  # TODO: how to trigger PermissionScope changelog entry when creating or removing a PermissionScopeUser, with the data.
  # touch works but it appear after the save occur, so it didn't works as expected
  belongs_to :permission_scope, touch: true
  belongs_to :user
end
