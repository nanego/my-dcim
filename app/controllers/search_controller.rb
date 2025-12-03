# frozen_string_literal: true

class SearchController < ApplicationController
  skip_verify_authorized

  def index
    @results = SearchResult.search(params[:query]&.downcase).map(&:searchable)

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end
end
