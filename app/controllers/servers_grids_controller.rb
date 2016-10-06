class ServersGridsController < ApplicationController

  def index

    unless params[:servers_grid].present?
      params[:servers_grid] = {"column_names"=>["id", "nom", "type"]}
    end

    @servers = ServersGrid.new(params[:servers_grid])

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
