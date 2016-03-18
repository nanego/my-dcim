class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|

      t.integer :source_port_id
      t.integer :destination_port_id

      t.timestamps null: false
    end
  end
end
