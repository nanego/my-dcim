json.array!(@server_states) do |server_state|
  json.extract! server_state, :id, :name
  json.url server_state_url(server_state, format: :json)
end
