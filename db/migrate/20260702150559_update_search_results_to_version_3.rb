# frozen_string_literal: true

class UpdateSearchResultsToVersion3 < ActiveRecord::Migration[8.1]
  def change
    update_view :search_results, version: 3, revert_to_version: 2
  end
end
