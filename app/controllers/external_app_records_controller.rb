# frozen_string_literal: true

class ExternalAppRecordsController < ApplicationController
  def index
    @external_app_records = ExternalAppRecord.includes(server: :frame).order("servers.name")
    @filter = ProcessorFilter.new(@external_app_records, params)
    @external_app_records = @filter.results
    @servers_count = Server.no_pdus.count

    @pagy, @external_app_records = pagy(@external_app_records)
  end

  def sync_all_servers_with_glpi
    if ExternalAppRequest.exists?(status: ["pending", "in_progress"], external_app_name: "glpi")
      render json: { error: "Another request is already in progress" }
    else
      request = ExternalAppRequest.create!(status: :pending, user: current_user, external_app_name: "glpi")
      SyncWithGlpiJob.perform_later

      render json: { request_id: request.id, status: request.status, progress: request.progress }
    end
  end
end
