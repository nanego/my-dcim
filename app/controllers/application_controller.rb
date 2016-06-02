class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  before_filter :authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def after_sign_in_path_for(resource)
    #return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    #=> with our setup, omniauth.origin always contain sign_in page since user was first redirected on it
    return stored_location_for(resource) || root_path
  end

  def track_updated_values(object, new_params)
    new_params.stringify_keys! # Avoid symbol keys
    updated_values = {}
    old_values = object.attributes
    object.attributes = object.attributes.merge(new_params)
    object.changed.each do |attribute|
      updated_values[attribute] = [old_values[attribute].to_s, new_params[attribute]]
    end
    return updated_values
  end

end
