# frozen_string_literal: true

class CreateClusters < ActiveRecord::Migration[4.2]
  def change
    create_table :clusters do |t|
      t.string :title

      t.timestamps null: false
    end
    add_column :serveurs, :cluster_id, :integer
  end
end
