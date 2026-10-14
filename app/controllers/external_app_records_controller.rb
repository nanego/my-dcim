# frozen_string_literal: true

class ExternalAppRecordsController < ApplicationController
  before_action do
    breadcrumb.add_step(Server.model_name.human, servers_path)
  end

  def index
    authorize! @external_app_records = ExternalAppRecord.includes(:server, :frame).order("servers.name")
    @filter = ProcessorFilter.new(@external_app_records, params)
    @external_app_records = @filter.results

    @pagy, @external_app_records = pagy(@external_app_records)

    @last_sync = requests.completed.order(:updated_at).last
    @running_request = requests.active.first
    @last_failure = requests.failed.where(updated_at: (@last_sync&.updated_at || Time.zone.at(0))..).last
  end

  def settings
    authorize!

    @settings = ExternalAppRecordSetting.new(settings_params)

    return unless params[:commit]

    @settings.save

    redirect_to external_app_records_path, notice: t(".flashes.saved")
  end

  def sync_all_servers_with_glpi
    authorize!

    requests.stale.find_each { |request| request.fail!(t(".abandoned")) }

    if requests.active.exists?
      render json: { error: t(".already_running") }
    else
      request = requests.create!(status: :pending, user: current_user)
      SyncWithGlpiJob.perform_later

      render json: { request_id: request.id, status: request.status, progress: request.progress }
    end
  end

  private

  def requests
    ExternalAppRequest.where(external_app_name: ExternalAppRecord::GLPI_APP_NAME)
  end

  def settings_params
    params[:external_app_record_setting]&.permit(category_glpi_sync_types: {}) || {}
  end
end
