# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error
  has_many :bays, dependent: :restrict_with_error
  has_many :servers, through: :modeles

  scope :sorted, -> { order(:name) }
  scope :with_servers_count, -> { left_joins(:servers).group(:id).select("manufacturers.*, COUNT(servers.id) AS servers_count") }

  delegate :to_s, to: :name
end
