class SyncWithGlpiJob < ApplicationJob
  queue_as :default

  def perform(*args)

    request = ExternalAppRequest.find_by(status: 'pending', external_app_name: 'glpi')
    request.update(status: :in_progress)

    begin

      client = GlpiClient.new
      servers = Server.no_pdus
      servers_count = servers.count

      Rails.logger.info "Synchronizing #{servers_count} servers with GLPI records:"
      puts "Synchronizing #{servers_count} servers with GLPI records:"

      servers.each_with_index do |server, index|
        ExternalAppRecord.sync_server_with_glpi(server, client)

        puts "Processed #{index + 1} servers so far" if (index + 1) % 25 == 0
        request.update(progress: (index + 1) * 100 / servers_count)
      end

      request.update(status: :completed, progress: 100)

    rescue StandardError => e
      request.update(status: :failed)
      Rails.logger.error "ExternalAppRequest failed: #{e.message}"
    end

  end
end
