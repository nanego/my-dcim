# frozen_string_literal: true

json.array! @maintenance_contracts, partial: 'maintenance_contracts/maintenance_contract', as: :maintenance_contract
