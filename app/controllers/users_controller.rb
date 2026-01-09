# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[show edit update destroy reset_authentication_token suspend unsuspend]
  before_action only: %i[new show edit] do
    breadcrumb.add_step(User.model_name.human.pluralize, users_url)
  end

  def index
    @filter = ProcessorFilter.new(User.order(sign_in_count: :desc), params)

    authorize! @users = @filter.results
  end

  def show; end

  def new
    authorize! @user = User.new
  end

  def add_user
    authorize! @user = User.new(secure_params)

    if @user.save
      redirect_to users_path, notice: t(".flashes.created")
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(secure_params)
      redirect_to users_path, notice: t(".flashes.updated")
    else
      render :edit, status: :unprocessable_content
    end
  end

  destroy_confirmation
  def destroy
    @user.destroy

    redirect_to users_path(search_params), notice: t(".flashes.destroyed")
  end

  def reset_authentication_token
    @user.regenerate_authentication_token!

    redirect_to edit_user_registration_path(@user), notice: t(".flashes.authentication_token_reset")
  end

  def suspend
    @user.suspend!

    redirect_to users_path(search_params), notice: t(".flashes.suspended")
  end

  def unsuspend
    @user.unsuspend!

    redirect_to users_path(search_params), notice: t(".flashes.unsuspended")
  end

  private

  def secure_params
    params.expect(user: %i[email name role is_admin])
  end

  def search_params
    params.permit(*UsersProcessor.fields_set)
  end

  def set_user
    authorize! @user = User.find(params[:id])
  end
end
