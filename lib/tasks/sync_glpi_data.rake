# frozen_string_literal: true

namespace :sync_glpi_data do

  desc "Sync all servers with GLPI records"
  task :sync_all_servers => :environment do

    client = GlpiClient.new

    servers = Server.no_pdus

    puts "Synchronizing #{servers.count} servers with GLPI records:"

    servers.each_with_index do |server, index|
      puts "Processed #{index + 1} servers so far" if (index + 1) % 25 == 0
      ExternalAppRecord.sync_server_with_glpi(server, client)
    end

  end

  task :clear_all_external_records => :environment do
      ExternalAppRecord.destroy_all
  end

end
