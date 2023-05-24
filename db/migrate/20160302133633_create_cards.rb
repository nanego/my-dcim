# frozen_string_literal: true

class CreateCards < ActiveRecord::Migration[4.2]
  def change
    create_table :cards do |t|
      t.string :name
      t.integer :port_type_id
      t.integer :port_quantity
    end
    create_table :port_types do |t|
      t.string :name
    end
    PortType.create!(name:'FC')
    PortType.create!(name:'RJ')
    PortType.create!(name:'VGA')
    PortType.create!(name:'SCSI')
    PortType.create!(name:'ISCI')
    PortType.create!(name:'SAS')
    PortType.create!(name:'IPMI')
  end
end
