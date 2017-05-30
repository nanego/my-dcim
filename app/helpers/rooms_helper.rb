module RoomsHelper

  def current_filters
    html = "<h5>"
    if params[:cluster_id].present?
      @cluster = Cluster.find_by_id(params[:cluster_id])
      html << "<span>Cluster : #{@cluster.name}</span>" if @cluster.present?
    end
    if params[:gestion_id].present?
      @gestion = Gestion.find_by_id(params[:gestion_id])
      html << "<span>Gestionnaire : #{@gestion.name}</span>" if @gestion.present?
    end
    html << "</h5>"
    html.html_safe
  end

end
