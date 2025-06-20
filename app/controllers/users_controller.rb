# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, except: :show
  before_action :set_user, only: %i[show update destroy reset_authentication_token suspend unsuspend]
  before_action only: %i[new show] do
    breadcrumb.add_step(User.model_name.human.pluralize, users_url)
  end

  def index
    @filter = ProcessorFilter.new(User.order(sign_in_count: :desc), params)
    @users = @filter.results
  end

  def show
    if !current_user.admin? && @user != current_user
      redirect_back_or_to root_path, alert: t(".flashes.access_denied")
    end
  end

  def new
    @user = User.new
  end

  def add_user
    @user = User.new(secure_params)

    if @user.save
      redirect_to users_path, notice: t(".flashes.created")
    else
      render :new
    end
  end

  def update
    if @user.update(secure_params)
      redirect_to users_path, notice: t(".flashes.updated")
    else
      redirect_to users_path, alert: t(".flashes.cant_be_updated")
    end
  end

  def destroy
    @user.destroy

    redirect_to users_path, notice: t(".flashes.destroyed")
  end

  def reset_authentication_token
    @user.regenerate_authentication_token!

    redirect_to edit_registration_path(@user), notice: t(".flashes.authentication_token_reset")
  end

  def suspend
    @user.suspend!

    redirect_to users_path, notice: t(".flashes.suspended")
  end

  def unsuspend
    @user.unsuspend!

    redirect_to users_path, notice: t(".flashes.unsuspended")
  end

  private

  def secure_params
    params.expect(user: %i[role email name])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
