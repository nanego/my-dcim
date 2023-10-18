# frozen_string_literal: true

OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:openid_connect] = OmniAuth::AuthHash.new(
  provider: :openid_connect,
  uid: 'user_unique_id',
  info: {
    email: 'jack.dalton@test.test',
    name: 'John Doe'
    # Add other user information as needed for your tests
  },
  credentials: {
    token: 'valid_access_token',
    expires_at: Time.zone.now + 1.hour
  }
)

OmniAuth.config.mock_auth[:openid_connect_failure] = :invalid_credentials

OmniAuth.config.mock_auth[:openid_connect_unknown_user] = OmniAuth::AuthHash.new(
  provider: :openid_connect,
  uid: 'user_unique_id',
  info: {
    email: 'unknown_user_from_oidc@test.test',
    name: 'Unknown User'
  },
  credentials: {
    token: 'valid_access_token',
    expires_at: Time.zone.now + 1.hour
  }
)
