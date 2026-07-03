# frozen_string_literal: true

class UpgradeSearchResultsViewVersion < ActiveRecord::Migration[8.1]
  def change
    drop_view :search_results, revert_to_version: 2

    create_view :search_results, version: 3
  end
end
