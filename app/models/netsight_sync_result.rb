# frozen_string_literal: true

class NetsightSyncResult < ApplicationRecord
  STATUSES_BY_KIND = {
    "vlan" => %w[differs default_vlan_only no_netsight_vlans free_text unknown_port],
    "link" => %w[matches differs not_cabled_in_dcim broken_path],
    "switch" => %w[netsight_unreachable serial_to_complete name_serial_mismatch serial_not_in_netsight not_in_netsight],
    "numbering" => %w[shifted unknown_ports],
  }.freeze

  belongs_to :external_app_request
  belongs_to :server
  belongs_to :port, optional: true
  has_one :frame, through: :server

  enum :kind, STATUSES_BY_KIND.keys.index_by(&:itself), prefix: true
  enum :status, STATUSES_BY_KIND.values.flatten.uniq.index_by(&:itself), prefix: true

  validate :status_matches_kind

  scope :applicable, lambda {
    where(applied_at: nil).merge(
      where(kind: :vlan, status: :differs).where.not(port_id: nil).or(where(kind: :switch, status: :serial_to_complete)),
    )
  }

  def applicable?
    applied_at.nil? && ((kind_vlan? && status_differs? && port.present?) ||
                        (kind_switch? && status_serial_to_complete?))
  end

  # Writes the Netsight value in DCIM, unless DCIM changed since the synchronization
  def apply!
    return false unless applicable? && unchanged_in_dcim?

    transaction do
      kind_vlan? ? apply_vlans : server.update!(numero: netsight_value)
      update!(applied_at: Time.current)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  # Both ends of a cable carry the same VLANs (see Port#connect_to_port)
  def apply_vlans
    [port, port.paired_connection&.port].compact.each { |p| p.update!(vlans: netsight_value) }
  end

  def unchanged_in_dcim?
    return server.numero == dcim_value if kind_switch?

    Netsight::Client::Port.normalize_vlans(port.vlans) == Netsight::Client::Port.normalize_vlans(dcim_value)
  end

  def status_matches_kind
    errors.add(:status, :inclusion) unless STATUSES_BY_KIND.fetch(kind.to_s, []).include?(status)
  end
end
