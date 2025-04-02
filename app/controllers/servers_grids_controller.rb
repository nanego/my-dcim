# frozen_string_literal: true

class ServersGridsController < ApplicationController
  DEFAULT_PARAMS = { "column_names" => ["id", "name", "S/N", "type", "frame"], "order" => "name" }.freeze

  def index
    respond_to do |format|
      format.html do
        if params[:servers_grid].present?
          save_request_in_session(params.to_unsafe_h.slice(:servers_grid))
        else
          params[:servers_grid] = DEFAULT_PARAMS
        end

        if session[:servers_grid_params].present? && session[:servers_grid_params][current_user.id.to_s].present? && params[:reset] != 't'
          @merged_params = params.to_unsafe_h.slice(:servers_grid).merge(session[:servers_grid_params][current_user.id.to_s])
        else
          @merged_params = params.to_unsafe_h.slice(:servers_grid)
        end

        begin
          @servers = ServersGrid.new(@merged_params[:servers_grid])
        rescue StandardError => e
          @servers = ServersGrid.new(params[:servers_grid])
          logger.error e.message
        end
      end
      format.csv do
        @servers = ServersGrid.new(params.to_unsafe_h[:servers_grid])
        send_data @servers.to_csv
      end
    end
  end

  private

  def save_request_in_session(params)
    session[:servers_grid_params] = { current_user.id => params }
  end
end
