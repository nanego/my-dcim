# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    @results = if params[:query]
                 search_result = ServerFrameView.search(params[:query])
                 (search_result.servers + search_result.frames).sort_by(&:name)
               else
                 []
               end

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end
end
