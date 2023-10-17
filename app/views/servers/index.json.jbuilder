# frozen_string_literal: true

json.array!(@servers) do |server|
  json.extract! server, :id, :name, :modele_id,
                :numero, :cluster, :critique
  json.url server_url(server, format: :json)
end
