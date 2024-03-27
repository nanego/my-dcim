# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only, :except => :show
  before_action :set_user, only: [:show, :update, :destroy, :reset_authentication_token]

  def index
    @users = sorted User.order('sign_in_count desc')
  end

  def show
    unless current_user.admin?
      unless @user == current_user
        redirect_to :back, :alert => "Access denied."
      end
    end
  end

  def update
    if @user.update(secure_params)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def new
    @user = User.new
  end

  def add_user
    @user = User.new(secure_params)
    if @user.save
      redirect_to users_path, :notice => "User created."
    else
      render :new
    end
  end

  def destroy
    @user.destroy
    redirect_to users_path, :notice => "User deleted."
  end

  def reset_authentication_token
    @user.regenerate_authentication_token!

    redirect_to edit_registration_path(@user), notice: t(".flashes.authentication_token_reset")
  end

  private

  def admin_only
    unless current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end

  def secure_params
    params.require(:user).permit(:role, :email, :name)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
