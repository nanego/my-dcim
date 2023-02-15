class Maintainer < ActiveRecord::Base

  has_many :maintenance_contracts, dependent: :restrict_with_error

  def to_s
    name
  end
end
