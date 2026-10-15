# frozen_string_literal: true

class ExternalAppRecordsProcessor < ApplicationProcessor
  include Sortable

  SORTABLE_FIELDS = %w[
    server_id servers.name servers.numero external_name external_id external_serial frames.name
  ].freeze

  map :frame_ids, filter_with: :non_empty_array do |frame_ids:|
    raw.joins(server: :frame).where(frames: { id: frame_ids })
  end

  map :modele_ids, filter_with: :non_empty_array do |modele_ids:|
    raw.joins(:server).where(servers: { modele_id: modele_ids })
  end

  map :server_name do |server_name:|
    raw.joins(:server).where(Server.arel_table[:name].matches("%#{server_name}%"))
  end

  map :external_serial_status, filter_with: :non_empty_array do |external_serial_status:|
    scopes = {
      "found" => raw.where.not(external_serial: [nil, ""]),
      "not_found" => raw.where(external_serial: [nil, ""]),
    }

    scopes.values_at(*external_serial_status).compact.reduce(:or) || raw
  end

  sortable fields: SORTABLE_FIELDS
end
