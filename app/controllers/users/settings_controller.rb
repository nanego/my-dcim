# frozen_string_literal: true

module Users
  class SettingsController < ApplicationController
    before_action :set_user, only: %i[edit update]

    def edit; end

    def update
      if @user.update(settings_params)
        redirect_to edit_users_settings_path, notice: t(".flashes.updated")
      else
        render :edit, status: :unprocessable_content
      end
    end

    private

    def set_user
      @user = current_user
    end

    def settings_params
      params.expect(
        user: %i[locale theme items_per_page visualization_bay_default_background_color visualization_bay_default_orientation]
      )
    end
  end
end
