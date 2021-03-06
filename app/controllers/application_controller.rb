class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :prepare_exception_notifier

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    #return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    #=> with our setup, omniauth.origin always contain sign_in page since user was first redirected on it
    return stored_location_for(resource) || root_path
  end

  def track_updated_values(object, new_params)
    new_params = new_params.to_unsafe_h.stringify_keys! # Avoid symbol keys
    updated_values = {}
    old_values = object.attributes
    object.assign_attributes(new_params)
    object.changed.each do |attribute|
      updated_values[attribute] = [old_values[attribute].to_s, new_params[attribute]] if old_values[attribute] != new_params[attribute]
    end
    return updated_values
  end

  private

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      :current_user => current_user
    }
  end

end
