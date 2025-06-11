# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    query = params[:query]&.downcase

    @results = if params[:query]
                 search_result = ServerFrameView.search(query)
                 (search_result.servers + search_result.frames).sort_by { |r| r.name&.downcase }
               else
                 []
               end

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end
end
