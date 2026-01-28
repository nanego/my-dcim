# frozen_string_literal: true

# Fix duplicated slots
# When duplicated slots have been created without "SL" prefix, we move all cards from wrong slots "1", "2", etc. to correct slots "SL1", "SL2", etc.

namespace :duplicated_slots do
  desc "Fix duplicated slots"
  task fix: :environment do
    Modele.includes(enclosures: :composants)
      .find_each do |modele|
        servers = []
        modele.enclosures.each do |enclosure|
          composants_names = enclosure.composants.map(&:name)
          if composants_names.include?("SL1") && composants_names.include?("1")
            # Potential duplicated slot
            puts "****** Modele ##{modele.id} - #{modele.name}"

            enclosure.composants.each do |composant|
              if composant.name.to_i.to_s == composant.name
                # Duplicated slot
                puts "****** Composant ##{composant.id} - #{composant.name}"
                correct_composant = enclosure.composants.find_by(name: "SL#{composant.name}")
                puts "****** correct_composant ##{correct_composant.id} - #{correct_composant.name}"
                composant.cards.each do |card|
                  card.composant = correct_composant
                  card.save
                  puts "****** Updated card ##{card.id} - #{card.name}"
                  servers << card.server
                  # puts "****** Card ##{card.id} - #{card.name}"
                end
              end
            end
          end
        end

        servers.uniq!
        puts "****** #{servers.size} serveurs : #{servers.map(&:name).sort}" if servers.present?
    end
  end
end
