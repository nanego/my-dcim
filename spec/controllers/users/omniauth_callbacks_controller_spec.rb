# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Users::OmniauthCallbacksController do
  let(:user) { User.find_or_create_by(email: 'jack.dalton@test.test') }

  describe '#openid_connect' do
    before { user }

    it 'creates a new user with valid authentication', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:openid_connect]

      expect(controller.current_user).to be_nil

      get :openid_connect

      expect(response).to redirect_to(root_path)
      expect(controller.current_user).to eq(user)
    end

    it 'does not create a new user with unknown user', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:openid_connect_unknown_user]

      expect do
        get :openid_connect
      end.not_to change(User, :count)

      expect(controller.current_user).to be_nil
    end
  end
end
