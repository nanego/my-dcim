# frozen_string_literal: true

json.array!(@contact_assignments) do |contact_assignment|
  json.extract! contact_assignment, :id, :site_id, :contact_id, :contact_role_id
  json.url contact_assignment_url(contact_assignment, format: :json)
end
