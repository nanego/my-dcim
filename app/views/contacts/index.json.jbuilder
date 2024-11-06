# frozen_string_literal: true

json.array!(@contacts) do |contact|
  json.extract! contact, :id, :first_name, :last_name, :phone_number, :email
  json.url contact_url(contact, format: :json)
end
