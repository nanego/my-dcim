# frozen_string_literal: true

class ContractType < ApplicationRecord
  has_changelog

  has_many :maintenance_contracts, dependent: :restrict_with_error

  def to_s
    name
  end
end
