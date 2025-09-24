# frozen_string_literal: true

class PermissionScope < ApplicationRecord
  has_changelog

  enum :role, { reader: 0, writer: 1 }

  has_many :permission_scope_domains, dependent: :destroy
  has_many :domaines, through: :permission_scope_domains
  has_many :permission_scope_users, dependent: :destroy
  has_many :users, through: :permission_scope_users

  validates :name, presence: true
  validate :validate_domains

  def to_s
    name
  end

  def allowed_domains
    return Domaine.all if all_domains?

    domaines
  end

  private

  def validate_domains
    return if all_domains?
    return unless domaines.empty?

    errors.add(:domaine_ids, :blank)
  end
end
