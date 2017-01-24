class MaintenanceContract < ActiveRecord::Base

  belongs_to :maintainer
  belongs_to :contract_type
  belongs_to :server

  validates_uniqueness_of :server_id

end
