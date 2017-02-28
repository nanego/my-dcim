class ServersGridsController < ApplicationController

  def index

    if params[:servers_grid].present?
      session[:servers_grid_params] = {current_user.id => params[:servers_grid]}
    else
      params[:servers_grid] = {"column_names"=>["id", "nom", "type"]}
    end

    if session[:servers_grid_params].present? && session[:servers_grid_params][current_user.id.to_s].present?
      merged_params = params.fetch(:servers_grid, {}).merge(session[:servers_grid_params][current_user.id.to_s])
    else
      merged_params = params.fetch(:servers_grid, {})
    end
    @servers = ServersGrid.new(merged_params)

    respond_to do |format|
      format.html
      format.csv { send_data @servers.to_csv }
    end
  end

  def reseau
    params[:servers_grid] = {"column_names"=>%W(id
                                               nom
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
                                               action_conf_reseau)
    }
    @servers = ServersGrid.new(params[:servers_grid])

    respond_to do |format|
      format.html
      format.pdf do
        render layout: 'pdf.html',
               show_as_html: params[:debug].present?,
               pdf: 'servers'
      end
    end
  end
end
