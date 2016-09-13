class RenameParentClassesInPortTable < ActiveRecord::Migration
  def change
    Port.where(parent_type: 'CardsServeur').update_all(parent_type: 'CardsServer')
  end
end
