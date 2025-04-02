# frozen_string_literal: true

namespace :sync_glpi_data do
  desc "Sync all servers with GLPI records"
  task :sync_all_servers => :environment do
    client = GlpiClient.new

    servers = Server.glpi_synchronizable

    puts "Synchronizing #{servers.count} servers with GLPI records:"

    servers.each_with_index do |server, index|
      puts "Processed #{index + 1} servers so far" if ((index + 1) % 25).zero?
      ExternalAppRecord.sync_server_with_glpi(server, client)
    end
  end

  desc "Clear all ExternalAppRecord"
  task :clear_all_external_records => :environment do
    ExternalAppRecord.destroy_all
  end
end
