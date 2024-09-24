# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @results = if params[:query].present?
                 search(params[:query])
               else
                 { servers: Server.none, frames: Frame.none }
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
