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

  def frames_sort_order(type_of_view, lane_index = 2)
    lane_index = 2 if lane_index.nil?
    if type_of_view == 'back'
      if lane_index.even? #pair
        "desc"
      else
        "asc"
      end
    else
      if lane_index.even? #pair
        "asc"
      else
        "desc"
      end
    end
  end

  def sorted_frames_per_islet(frames, type_of_view)
    frames.sort_by do |f|
      if frames_sort_order(type_of_view, f.bay.lane) == 'asc'
        [ f.bay.islet.name.to_i, f.bay.lane.to_i, f.bay.position.to_i, f.position.to_i ]
      else
        [ f.bay.islet.name.to_i, f.bay.lane.to_i, -(f.bay.position.to_i), -(f.position.to_i) ]
      end
    end
  end

end
