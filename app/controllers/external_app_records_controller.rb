# frozen_string_literal: true

class ExternalAppRecordsController < ApplicationController
  def index
    @external_app_records = ExternalAppRecord.includes(server: :frame).order("servers.name")
    @filter = ProcessorFilter.new(@external_app_records, params)
    @external_app_records = @filter.results

    @synchronised_categories = Category.glpi_synchronizable.pluck(:name).compact_blank.join(", ")

    @pagy, @external_app_records = pagy(@external_app_records)
  end

  def settings
    @settings = ExternalAppRecordSetting.new(settings_params)

    return unless params[:commit]

    @settings.save

    redirect_to external_app_records_path, notice: t(".flashes.saved")
  end

  def sync_all_servers_with_glpi
    if ExternalAppRequest.exists?(status: %w[pending in_progress], external_app_name: "glpi")
      render json: { error: "Another request is already in progress" }
    else
      request = ExternalAppRequest.create!(status: :pending, user: current_user, external_app_name: "glpi")
      SyncWithGlpiJob.perform_later

      render json: { request_id: request.id, status: request.status, progress: request.progress }
    end
  end

  def settings_params
    params[:external_app_record_setting]&.permit(category_ids: []) || {}
  end
end
