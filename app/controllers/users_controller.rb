# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show
  before_action :set_user, only: %i[show update destroy reset_authentication_token suspend unsuspend]

  def index
    @users = sorted User.order('sign_in_count desc')
  end

  def show
    unless current_user.admin?
      unless @user == current_user
        redirect_back_or_to root_path, alert: t(".flashes.access_denied")
      end
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

  def admin_only
    return if current_user.admin?

    redirect_to root_path, alert: t(".flashes.access_denied")
  end

  def secure_params
    params.require(:user).permit(:role, :email, :name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
