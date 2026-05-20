# frozen_string_literal: true

class SearchController < ApplicationController
  skip_verify_authorized

  def index
    @results = authorize! SearchResult.search(params[:search_query])
    @results = authorized_scope(@results)

    @results = @results.limit(10) unless request.referer.nil? || URI(request.referer).path == search_path

    @results = @results.map(&:searchable)

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
    end
  end
end
