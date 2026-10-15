# frozen_string_literal: true

namespace :servers do
  desc "List servers outside their frame or overlapping another server (read-only)"
  task check_rack_positions: :environment do
    servers = Server.no_pdus
      .where.not(position: nil)
      .includes(:modele, frame: { bay: { islet: :room } })
      .order(:frame_id, position: :desc)

    count = 0
    servers.each do |server|
      # Run the placement validations as if the position had just been typed
      server.position_will_change!
      server.valid?(:rack_placement)
      next if server.errors[:position].empty?

      count += 1
      server.errors[:position].each do |message|
        puts "#{server.frame.name_with_room_and_islet} | #{server.name} (#{server.rack_units_label}) | #{message}"
      end
    end

    puts "#{count} server(s) with an invalid rack position"
  end
end
