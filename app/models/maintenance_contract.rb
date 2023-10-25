# frozen_string_literal: true

class MaintenanceContract < ApplicationRecord
  has_changelog

  belongs_to :maintainer, optional: true
  belongs_to :contract_type, optional: true
  belongs_to :server, optional: true

  validates_uniqueness_of :server_id
end
