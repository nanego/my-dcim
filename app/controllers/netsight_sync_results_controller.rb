# frozen_string_literal: true

class NetsightSyncResultsController < ApplicationController
  APP_NAME = "netsight"

  before_action do
    breadcrumb.add_step(Server.model_name.human, servers_path)
  end

  def index
    authorize!

    @kind = params[:kind].presence_in(NetsightSyncResult.kinds.keys) || "vlan"
    @counts = visible_results.group(:kind).count
    results = visible_results.where(kind: @kind).eager_load(:server, :frame).preload(port: [{ attachable: { card_type: :port_type } }, { connection: :cable }])
    @filter = ProcessorFilter.new(results, params)
    @pagy, @results = pagy(@filter.results.order("servers.name", :if_name))

    @configured = Netsight::Client.configured?
    @last_sync = requests.completed.order(:updated_at).last
    @running_request = requests.active.first
    @last_failure = requests.failed.where(updated_at: (@last_sync&.updated_at || Time.zone.at(0))..).last
  end

  def sync
    authorize!

    return render json: { error: t(".not_configured") } unless Netsight::Client.configured?

    requests.stale.find_each { |request| request.fail!(t(".abandoned")) }

    if requests.active.exists?
      render json: { error: t(".already_running") }
    else
      request = requests.create!(status: :pending, user: current_user)
      SyncWithNetsightJob.perform_later

      render json: { request_id: request.id, status: request.status, progress: request.progress }
    end
  end

  def apply
    authorize!

    applied = visible_results.applicable.where(id: params[:ids]).count(&:apply!)

    redirect_back_or_to netsight_sync_results_path, notice: t(".flashes.applied", count: applied)
  end

  private

  def requests
    ExternalAppRequest.where(external_app_name: APP_NAME)
  end

  def visible_results
    NetsightSyncResult.where(server_id: authorized_scope(Server.all).select(:id))
  end
end
