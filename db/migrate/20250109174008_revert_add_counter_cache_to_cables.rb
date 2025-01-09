# frozen_string_literal: true

require_relative "20240403141149_add_counter_cache_to_cables"

class RevertAddCounterCacheToCables < ActiveRecord::Migration[7.2]
  def change
    revert AddCounterCacheToCables
  end
end
