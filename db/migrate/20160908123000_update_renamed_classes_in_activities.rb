class UpdateRenamedClassesInActivities< ActiveRecord::Migration
  def up
    PublicActivity::Activity.where(trackable_type: 'Serveur').update_all(trackable_type: 'Server')
    PublicActivity::Activity.where(trackable_type: 'CardsServeur').update_all(trackable_type: 'CardsServer')
    PublicActivity::Activity.where(trackable_type: 'Baie').update_all(trackable_type: 'Frame')
    PublicActivity::Activity.where(trackable_type: 'Salle').update_all(trackable_type: 'Room')

    PublicActivity::Activity.where(key: 'serveur.create').update_all(key: 'server.create')
    PublicActivity::Activity.where(key: 'serveur.update').update_all(key: 'server.update')
    PublicActivity::Activity.where(key: 'cards_serveur.create').update_all(key: 'cards_server.create')
    PublicActivity::Activity.where(key: 'cards_serveur.update').update_all(key: 'cards_server.update')
    PublicActivity::Activity.where(key: 'baie.create').update_all(key: 'frame.create')
    PublicActivity::Activity.where(key: 'baie.update').update_all(key: 'frame.update')
    PublicActivity::Activity.where(key: 'salle.create').update_all(key: 'room.create')
    PublicActivity::Activity.where(key: 'salle.update').update_all(key: 'room.update')

    PublicActivity::Activity.all.each do |activity|
      activity.parameters = {}
      activity.save
    end
  end
end
