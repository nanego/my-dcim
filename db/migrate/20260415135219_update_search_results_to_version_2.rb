# frozen_string_literal: true

class UpdateSearchResultsToVersion2 < ActiveRecord::Migration[8.0]
  def change
    update_view :search_results, version: 2, revert_to_version: 1
  end
end
