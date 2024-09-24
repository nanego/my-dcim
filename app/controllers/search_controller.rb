class SearchController < ApplicationController

  def index
    if params[:query].present?
      @results = search(params[:query])
    else
      @results = { servers: Server.none, frames: Frame.none }
    end

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end

  private

  def search(query)
    servers = Server.search(query)
    frames = Frame.search(query)

    { servers: servers, frames: frames }
  end
end
