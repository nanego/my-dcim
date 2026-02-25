# frozen_string_literal: true

class SearchController < ApplicationController
  skip_verify_authorized

  def index
    @results = authorize! SearchResult.search(params[:search_query])
    @results = authorized_scope(@results).map(&:searchable)

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end
end
