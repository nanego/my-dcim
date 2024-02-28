# frozen_string_literal: true

class ServersGridsController < ApplicationController
  DEFAULT_PARAMS = { "column_names" => ["id", "name", "S/N", "type", "frame"], "order" => "name" }

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
        rescue => ex
          @servers = ServersGrid.new(params[:servers_grid])
          logger.error ex.message
        end

      end
      format.csv do
        @servers = ServersGrid.new(params.to_unsafe_h[:servers_grid])
        send_data @servers.to_csv
      end
    end
  end

  def reseau
    params[:servers_grid] = { "column_names" => %W(id
                                                   name
                                                   modele
                                                   room
                                                   fc_total
                                                   fc_calcule
                                                   fc_utilise
                                                   rj45_total
                                                   rj45_calcule
                                                   rj45_utilise
                                                   rj45_futur
                                                   ipmi_utilise
                                                   ipmi_futur
                                                   rj45_cm
                                                   ipmi_dedie
                                                   slots
                                                   ip
                                                   etat_conf_reseau
                                                   action_conf_reseau) }
    @servers = ServersGrid.new(params[:servers_grid])

    respond_to do |format|
      format.html
      format.pdf do
        render show_as_html: params[:debug].present?,
               pdf: 'servers'
      end
    end
  end

  private

  def save_request_in_session(params)
    session[:servers_grid_params] = { current_user.id => params }
  end
end
