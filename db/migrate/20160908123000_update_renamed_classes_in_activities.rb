# frozen_string_literal: true

class MigrationPublicActivityActivity < ActiveRecord::Base
  self.table_name = :activities

  belongs_to :trackable, polymorphic: true
end

class UpdateRenamedClassesInActivities < ActiveRecord::Migration[4.2]
  def up
    MigrationPublicActivityActivity.where(trackable_type: 'Serveur').update_all(trackable_type: 'Server')
    MigrationPublicActivityActivity.where(trackable_type: 'CardsServeur').update_all(trackable_type: 'CardsServer')
    MigrationPublicActivityActivity.where(trackable_type: 'Baie').update_all(trackable_type: 'Frame')
    MigrationPublicActivityActivity.where(trackable_type: 'Salle').update_all(trackable_type: 'Room')

    MigrationPublicActivityActivity.where(key: 'serveur.create').update_all(key: 'server.create')
    MigrationPublicActivityActivity.where(key: 'serveur.update').update_all(key: 'server.update')
    MigrationPublicActivityActivity.where(key: 'cards_serveur.create').update_all(key: 'cards_server.create')
    MigrationPublicActivityActivity.where(key: 'cards_serveur.update').update_all(key: 'cards_server.update')
    MigrationPublicActivityActivity.where(key: 'baie.create').update_all(key: 'frame.create')
    MigrationPublicActivityActivity.where(key: 'baie.update').update_all(key: 'frame.update')
    MigrationPublicActivityActivity.where(key: 'salle.create').update_all(key: 'room.create')
    MigrationPublicActivityActivity.where(key: 'salle.update').update_all(key: 'room.update')

    MigrationPublicActivityActivity.update_all(parameters: {})
  end
end
