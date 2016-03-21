class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :title

      t.timestamps null: false
    end
    add_column :serveurs, :cluster_id, :integer
  end
end
