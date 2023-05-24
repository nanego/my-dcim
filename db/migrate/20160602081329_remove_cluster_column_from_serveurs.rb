# frozen_string_literal: true

class RemoveClusterColumnFromServeurs < ActiveRecord::Migration[4.2]
  def change
    remove_column :serveurs, :cluster, :boolean
  end
end
