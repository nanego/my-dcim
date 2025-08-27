# frozen_string_literal: true

class PermissionScope < ApplicationRecord
  has_changelog

  has_many :permission_scope_domains
  has_many :domaines, through: :permission_scope_domains
  has_many :permission_scope_users
  has_many :users, through: :permission_scope_users

  validates :name, presence: true

  def to_s
    name
  end
end
