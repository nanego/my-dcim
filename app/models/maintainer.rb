# frozen_string_literal: true

class Maintainer < ApplicationRecord
  has_many :maintenance_contracts, dependent: :restrict_with_error

  def to_s
    name
  end
end
