# frozen_string_literal: true

class NetsightSyncResultDecorator < ApplicationDecorator
  STATUS_COLORS = {
    "matches" => :success,
    "differs" => :danger,
    "default_vlan_only" => :secondary,
    "no_netsight_vlans" => :light,
    "free_text" => :info,
    "unknown_port" => :light,
    "not_cabled_in_dcim" => :warning,
    "broken_path" => :warning,
    "not_in_netsight" => :secondary,
    "netsight_unreachable" => :danger,
    "serial_to_complete" => :info,
    "name_serial_mismatch" => :danger,
    "serial_not_in_netsight" => :warning,
    "shifted" => :danger,
    "unknown_ports" => :warning,
  }.freeze

  class << self
    def status_options_for_select(kind)
      NetsightSyncResult::STATUSES_BY_KIND.fetch(kind).map { |status| [human_status(status), status] }
    end

    def human_status(status)
      NetsightSyncResult.human_attribute_name("status.#{status}")
    end
  end

  # The Netsight error is stored as the Netsight value of an unreachable switch
  def status_details
    return I18n.t("netsight_sync_results.index.unreachable_details", error: netsight_value) if status_netsight_unreachable?

    I18n.t("netsight_sync_results.index.numbering_details") if kind_numbering?
  end

  def status_to_badge_component
    BadgeComponent.new(self.class.human_status(status), color: STATUS_COLORS.fetch(status), variant: :pill)
  end
end
