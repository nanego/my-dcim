# frozen_string_literal: true

module NetsightSyncResultsHelper
  MAX_LISTED_VLANS = 8

  # The port as drawn on the rack views: shape of its type, cable color and name.
  # A click opens the connection form in the modal of ports/_modal_edit_port.
  def netsight_dcim_port_tag(port)
    card = port.card
    port_type = card&.card_type&.port_type or return

    tag.span(link_to_port(port.position, port, port_type, card.id, port.id), class: "js_connection_edit_port")
  end

  CONNECTION_STATUSES = %w[default_vlan_only free_text differs not_cabled_in_dcim broken_path].freeze
  SWITCH_PAGE_STATUSES = %w[unknown_port not_in_netsight shifted unknown_ports].freeze
  SWITCH_EDIT_STATUSES = %w[name_serial_mismatch serial_not_in_netsight].freeze
  NOTE_STATUSES = %w[netsight_unreachable].freeze

  # A button when the action runs from this page, a link when it happens on
  # another page, a short note when there is nothing to click, and nothing at
  # all when there is nothing to do
  def netsight_result_action(result)
    return tag.span(t("netsight_sync_results.index.applied_at", date: l(result.applied_at, format: :short)), class: "text-body-secondary text-nowrap") if result.applied_at
    return netsight_apply_button(result) if result.applicable?
    return tag.span(t("netsight_sync_results.index.notes.#{result.status}"), class: "text-body-secondary text-nowrap") if result.status.in?(NOTE_STATUSES)

    netsight_result_link(result)
  end

  # VLAN lists are shown with a space after each comma so that they wrap like the
  # other column, whatever the DCIM spelling. Trunks carry hundreds of VLANs: only
  # the first ones are shown, the full list goes in a tooltip.
  def netsight_vlans_tag(vlans)
    return value_or_nc(vlans) if vlans.blank?
    return tag.span(vlans, class: "text-break") unless Netsight::Client::Port.vlan_list?(vlans)

    list = vlans.split(/[\s,]+/).compact_blank
    return list.join(", ") if list.size <= MAX_LISTED_VLANS

    tag.span(netsight_vlans_text(vlans), title: list.join(", "))
  end

  def netsight_vlans_text(vlans)
    return vlans.to_s unless Netsight::Client::Port.vlan_list?(vlans)

    list = vlans.split(/[\s,]+/).compact_blank
    list.size > MAX_LISTED_VLANS ? "#{list.first(MAX_LISTED_VLANS).join(", ")}, … (#{list.size})" : list.join(", ")
  end

  private

  def netsight_apply_button(result)
    return unless allowed_to?(:apply?, with: NetsightSyncResultPolicy)

    button_to t("netsight_sync_results.index.apply"), apply_netsight_sync_results_path(ids: [result.id]),
              method: :patch, class: "btn btn-sm btn-outline-primary text-nowrap",
              title: netsight_apply_explanation(result),
              data: { controller: "tooltip", bs_placement: "left", bs_custom_class: "tooltip-explanation" }
  end

  def netsight_apply_explanation(result)
    none = t("netsight_sync_results.index.apply_help.none")
    t("netsight_sync_results.index.apply_help.#{result.kind}",
      dcim: result.kind_vlan? ? netsight_vlans_text(result.dcim_value).presence || none : result.dcim_value.presence || none,
      netsight: result.kind_vlan? ? netsight_vlans_text(result.netsight_value) : result.netsight_value)
  end

  def netsight_result_link(result)
    label, url = if result.status.in?(CONNECTION_STATUSES) && result.port && !(result.kind_link? && result.status_matches?)
                   [:edit_connection, connections_edit_path(from_port_id: result.port_id)]
                 elsif result.status.in?(SWITCH_PAGE_STATUSES)
                   [:show_switch, server_path(result.server)]
                 elsif result.status.in?(SWITCH_EDIT_STATUSES)
                   [:edit_switch, edit_server_path(result.server)]
                 end
    return unless label

    # The connection form opens in the modal of ports/_modal_edit_port, without leaving the page
    modal = label == :edit_connection
    link_to t("netsight_sync_results.index.#{label}"), url,
            class: class_names("text-nowrap", js_connection_edit_link_to: modal), data: { url: (url if modal) }
  end
end
