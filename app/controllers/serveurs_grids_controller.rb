class ServeursGridsController < ApplicationController

  def index

    unless params[:serveurs_grid].present?
      params[:serveurs_grid] = {"column_names"=>["id", "localisation", "rack", "nom", "type"]}
    end

    @serveurs = ServeursGrid.new(params[:serveurs_grid])
  end

  def reseau
    params[:serveurs_grid] = {"column_names"=>%W(id
                                               localisation
                                               nom
                                               modele
                                               salle
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
                                               conf_reseau
                                               action_conf_reseau)
    }
    @serveurs = ServeursGrid.new(params[:serveurs_grid])

    respond_to do |format|
      format.html
      format.pdf do
        render layout: 'pdf.html',
               show_as_html: params[:debug].present?,
               pdf: 'serveurs'
      end
    end
  end
end
