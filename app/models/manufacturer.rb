# frozen_string_literal: true

class Manufacturer < ApplicationRecord
  has_changelog

  has_many :modeles, dependent: :restrict_with_error
  has_many :bays, dependent: :restrict_with_error
  has_many :servers, through: :modeles

  scope :sorted, -> { order(:name) }
  scope :with_servers_count, lambda {
    left_joins(:servers)
      .group(:id)
      .select(arel_table.name => ["*"])
      .select(Server.arel_table[:id].count.as("servers_count"))
  }

  delegate :to_s, to: :name
end
