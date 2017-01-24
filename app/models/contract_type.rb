class ContractType < ActiveRecord::Base

  has_many :maintenance_contracts

  def to_s
    name
  end
end
