class PortsController < ApplicationController

  def index
    @baie = Baie.find(params[:baie_id])
    @salle = @baie.salle
    @serveurs = @baie.serveurs.includes(:cards_serveurs => [:ports, :composant]).order('position desc')
  end

end
