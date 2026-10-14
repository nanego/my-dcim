# frozen_string_literal: true

class SyncWithNetsightJob < ApplicationJob
  queue_as :default

  def perform
    request = ExternalAppRequest.find_by(status: "pending", external_app_name: "netsight") or return
    request.update(status: :in_progress)

    Netsight::Sync.new(request).call

    request.update(status: :completed, progress: 100)
  rescue StandardError => e
    request&.fail!(e.message)

    Rails.logger.error "ExternalAppRequest failed: #{e.message}"
  end
end
