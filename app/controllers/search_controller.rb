# frozen_string_literal: true

class SearchController < ApplicationController
  def index
    query = params[:query]&.downcase

    @results = if params[:query]
                 search_result = ServerFrameView.search(query)
                 (search_result.servers + search_result.frames).sort_by do |result|
                   levenshtein_distance(result.name.downcase, query)
                 end
               else
                 []
               end

    respond_to do |format|
      format.html # normal rendering for non-Turbo requests
      format.turbo_stream # turbo frame updates
    end
  end

  private

  def levenshtein_distance(str1, str2)
    m = str1.length
    n = str2.length
    dp = Array.new(m + 1) { Array.new(n + 1, 0) }

    (0..m).each { |i| dp[i][0] = i }
    (0..n).each { |j| dp[0][j] = j }

    (1..m).each do |i|
      (1..n).each do |j|
        cost = str1[i - 1] == str2[j - 1] ? 0 : 1
        dp[i][j] = [
          dp[i - 1][j] + 1,        # deletion
          dp[i][j - 1] + 1,        # insertion
          dp[i - 1][j - 1] + cost, # substitution
        ].min
      end
    end

    dp[m][n]
  end
end
