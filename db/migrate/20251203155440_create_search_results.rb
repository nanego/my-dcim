# frozen_string_literal: true

class CreateSearchResults < ActiveRecord::Migration[8.0]
  def change
    create_view :search_results
  end
end
