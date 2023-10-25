# frozen_string_literal: true

class MaintenanceContract < ApplicationRecord
  has_changelog

  belongs_to :maintainer
  belongs_to :contract_type
  belongs_to :server

  validates_uniqueness_of :server_id
end
