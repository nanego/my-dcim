# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    skip_verify_authorized

    skip_before_action :verify_authenticity_token, only: :create # rubocop:disable Rails/LexicallyScopedActionFilter
    skip_before_action :no_permission_scope, only: :destroy
  end
end
