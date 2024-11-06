# frozen_string_literal: true

json.array!(@contact_roles) do |contact_role|
  json.extract! contact_role, :id, :first_name, :last_name, :phone_number, :email
  json.url contact_role_url(contact_role, format: :json)
end
