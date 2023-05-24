# frozen_string_literal: true

class RenameParentClassesInPortTable < ActiveRecord::Migration[4.2]
  def change
    Port.where(parent_type: 'CardsServeur').update_all(parent_type: 'CardsServer')
  end
end
