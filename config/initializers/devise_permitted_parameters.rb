# frozen_string_literal: true

Rails.application.reloader.to_prepare do
  module DevisePermittedParameters # rubocop:disable Lint/ConstantDefinitionInBlock
    extend ActiveSupport::Concern

    included do
      before_action :configure_permitted_parameters
    end

    protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name])
    end
  end

  DeviseController.include DevisePermittedParameters
end
