class CreateBayTypes < ActiveRecord::Migration
  def change
    create_table :bay_types do |t|
      t.string :name
      t.integer :size
    end
    BayType.create(name: 'single', size: 1)
    BayType.create(name: 'double', size: 2)
  end
end
