# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ChangelogContextApplication
  include Localization
  include Pagy::Backend
  include Authorization

  acts_as_token_authentication_handler_for User

  before_action :authenticate_user!
  before_action :prepare_exception_notifier

  etag { Rails.application.importmap.digest(resolver: helpers) if request.format&.html? }

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # allow_browser versions: :modern

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  protect_from_forgery with: :null_session, if: -> { request.format.json? }

  rescue_from ActiveRecord::RecordNotFound, with: :show_not_found_error
  rescue_from ActiveRecord::RecordNotUnique, with: :show_api_error

  layout :layout_by_resource

  def after_sign_in_path_for(resource)
    # return request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    #=> with our setup, omniauth.origin always contain sign_in page since user was first redirected on it
    stored_location_for(resource) || root_path
  end

  # TODO: remove when fully moved in processor
  def sorted(collection)
    direction = %w[asc desc].include?(params[:sort]) ? params[:sort] : "desc"
    column = params[:sort_by]

    return collection unless column

    collection.reorder(column => direction)
  end

  def breadcrumb
    @breadcrumb ||= Breadcrumb.new do |b|
      b.root("Gestion de salle #{Rails.env.development? ? "(dev)" : "DCIM"}")
    end
  end
  helper_method :breadcrumb

  def redirect_to_new_or_to(options = {}, response_options = {})
    options = url_for(action: :new, create_another_one: "1") if params[:create_another_one].present?

    redirect_to options, response_options
  end

  def form_redirect_to(options = {}, response_options = {})
    if params[:redirect_to_on_success] == "back"
      redirect_back_or_to options, **response_options
    elsif params[:redirect_to_on_success]
      redirect_to params[:redirect_to_on_success], response_options
    else
      redirect_to options, response_options
    end
  end

  def form_redirect_to_new_or_to(options = {}, response_options = {})
    if params[:create_another_one].present?
      options = url_for(action: :new, create_another_one: "1", redirect_to_on_success: params[:redirect_to_on_success])

      redirect_to options, response_options
    else
      form_redirect_to(options, response_options)
    end
  end

  private

  def pagy_get_limit(vars)
    limit_params = vars[:limit] || Pagy::DEFAULT[:limit_param]

    params[limit_params] || current_user.items_per_page
  end

  def admin_only
    return if current_user.present? && current_user.admin?

    redirect_to root_path, alert: t("users.flashes.access_denied")
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user,
    }
  end

  def show_not_found_error(exception)
    raise exception unless request.format == :json

    head :not_found
  end

  def show_api_error(exception)
    raise exception unless request.format == :json

    render json: { exception: { name: exception.class.name, message: exception.message } }, status: :internal_server_error
  end

  def layout_by_resource
    if turbo_frame_request?
      false
    elsif devise_controller? && !user_signed_in?
      "devise"
    else
      "application"
    end
  end
end
