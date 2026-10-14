# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NetsightSyncResults::Review", :js do
  let(:user) { users(:admin) }
  let(:request_record) { ExternalAppRequest.create!(user:, external_app_name: "netsight", status: :completed) }
  let(:port) { Port.create!(position: 2, attachable: cards(:three), vlans: "u300") }

  def page_t(key, **) = I18n.t("netsight_sync_results.index.#{key}", locale: user.locale, **)

  before do
    NetsightSyncResult.create!(external_app_request: request_record, server: port.server, port:, kind: :vlan,
                               status: :differs, if_name: "1:7", dcim_value: "u300", netsight_value: "u201")
    NetsightSyncResult.create!(external_app_request: request_record, server: port.server, port:, kind: :link,
                               status: :matches, if_name: "1:7", netsight_peer: "SW_B 1:1",
                               dcim_path: "PP-0101 12FC:1 › PatchPanel 0101 12FC:1 › SW_B 48FC:1")
    sign_in user
  end

  it "applies the Netsight VLANs of a port", :aggregate_failures do
    visit netsight_sync_results_path

    expect(page).to have_text("u201")
    click_on page_t(:apply)

    expect(page).to have_text(I18n.t("netsight_sync_results.apply.flashes.applied", count: 1, locale: user.locale))
    expect(port.reload.vlans).to eq("u201")
  end

  it "lists the links between switches" do
    visit netsight_sync_results_path

    click_on page_t("kinds.link")

    expect(page).to have_text("PP-0101 12FC:1 › PatchPanel 0101 12FC:1 › SW_B 48FC:1")
  end

  it "edits a connection in a modal without leaving the page", :aggregate_failures do
    link = NetsightSyncResult.create!(external_app_request: request_record, server: port.server, port:, kind: :link,
                                      status: :not_cabled_in_dcim, if_name: "1:7", netsight_peer: "SW_B 1:1")
    visit netsight_sync_results_path(kind: "link")

    # Bootstrap ignores a hide request while the modal is still opening
    page.execute_script(<<~JS)
      document.querySelector("#edit_port_modal").addEventListener("shown.bs.modal", () => document.body.dataset.modalShown = "")
    JS
    click_on page_t(:edit_connection)
    expect(page).to have_css("body[data-modal-shown]")

    within("#edit_port_modal") do
      expect(page).to have_field("connection[vlans]")
      fill_in "connection[vlans]", with: "u42"
      click_on I18n.t("action.edit", locale: user.locale)
    end

    expect(page).to have_no_css("#edit_port_modal.show")
    expect(page).to have_current_path(netsight_sync_results_path(kind: "link"))
    expect(port.reload.vlans).to eq("u42")
    expect(link).to be_persisted
  end

  it "opens the connection of a port in a modal, with its Netsight block", :aggregate_failures do
    port.server.update!(name: "SW_TEST01:Slot2")
    visit netsight_sync_results_path

    find(".js_connection_edit_port a.port").click

    within("#edit_port_modal") do
      expect(page).to have_field("connection[vlans]")
      expect(page).to have_css("turbo-frame#netsight_port", text: "STORAGE-1 CTRL")
      expect(page).to have_no_link(I18n.t("ports.netsight_port.show.sync_page", locale: user.locale))
      expect(page).to have_no_css("turbo-frame#netsight_port .card-footer")
    end
    expect(page).to have_current_path(netsight_sync_results_path)
  end

  it "starts a synchronization" do
    visit netsight_sync_results_path

    click_on page_t(:start_synchronization)

    expect(page).to have_text(page_t(:synchronizing))
  end
end
