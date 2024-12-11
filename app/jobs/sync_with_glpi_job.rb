# frozen_string_literal: true

class SyncWithGlpiJob < ApplicationJob
  queue_as :default

  def perform
    request = ExternalAppRequest.find_by(status: 'pending', external_app_name: 'glpi')
    request.update(status: :in_progress)

    begin
      client = GlpiClient.new
      servers = Server.glpi_synchronizable
      servers_count = servers.count

      Rails.logger.info { "Synchronizing #{servers_count} servers with GLPI records:" }
      Rails.logger.debug { "Synchronizing #{servers_count} servers with GLPI records:" }

      servers.each_with_index do |server, index|
        ExternalAppRecord.sync_server_with_glpi(server, client)

        Rails.logger.debug { "Processed #{index + 1} servers so far" } if ((index + 1) % 25).zero?

        request.update(progress: (index + 1) * 100 / servers_count)
      end

      # Clear ignored servers
      ExternalAppRecord.where(server: Server.where.not(id: servers)).destroy_all

      request.update(status: :completed, progress: 100)
    rescue StandardError => e
      request.update(status: :failed)

      Rails.logger.error "ExternalAppRequest failed: #{e.message}"
    end
  end
end
