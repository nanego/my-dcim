# frozen_string_literal: true

json.array!(@pdus) do |pdu|
  json.extract! pdu, :id, :name, :modele_id,
                :numero, :cluster, :critique
  json.url power_distribution_unit_url(pdu, format: :json)
end
