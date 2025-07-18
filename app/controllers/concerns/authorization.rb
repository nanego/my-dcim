# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    authorize :user, through: :action_policy_user

    # verify_authorized

    rescue_from ActionPolicy::Unauthorized, with: :user_not_authorized

    def action_policy_user
      current_user
    end

    def user_not_authorized(exception)
      logger.debug "[Authorization] user unauthorized. #{exception.policy}##{exception.rule} returns false"
      redirect_back fallback_location: root_path, alert: exception.result.message
    end
  end

  def policy_for(record:, **)
    # From https://actionpolicy.evilmartians.io/#/./decorators
    record = record.object if record.is_a?(::ApplicationDecorator)
    super
  end

  protected

  def authorized_params(key = nil, context: :default, with: nil)
    key ||= implicit_authorization_target&.to_s&.downcase
    authorized(params.require(key&.to_sym), as: context, with:)
  end
end
