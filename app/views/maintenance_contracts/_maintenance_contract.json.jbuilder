# frozen_string_literal: true

json.extract! maintenance_contract, :id, :start_date, :end_date, :maintainer_id, :contract_type_id, :created_at, :updated_at
json.url maintenance_contract_url(maintenance_contract, format: :json)
