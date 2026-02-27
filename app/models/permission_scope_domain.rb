# frozen_string_literal: true

class PermissionScopeDomain < ApplicationRecord
  belongs_to :permission_scope
  belongs_to :domaine

  delegate :to_s, to: :permission_scope
end
