# frozen_string_literal: true

class Domaine < ApplicationRecord
  has_changelog

  has_many :servers, dependent: :restrict_with_error
  has_many :permission_scope_domains, dependent: :destroy
  has_many :permission_scopes, through: :permission_scope_domains

  scope :sorted, -> { order(Arel.sql("LOWER(name)")) }

  delegate :to_s, to: :name
end
