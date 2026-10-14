# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Ports::NetsightVlans", :js do
  let(:port) { ports(:four) }
  let(:user) { users(:admin) }

  def netsight_t(key) = I18n.t("ports.netsight_port.show.#{key}", locale: user.locale)

  before { servers(:one).update!(name: "SW_TEST01:Slot2") }

  it "shows the Netsight data of the port and copies its VLANs into the form", :aggregate_failures do
    sign_in user

    visit connections_edit_path(from_port_id: port.id)

    within("turbo-frame#netsight_port") do
      expect(page).to have_text(netsight_t(:title))
      expect(page).to have_text("STORAGE-1 CTRL")
      expect(page).to have_text(netsight_t(:differs_from_dcim))
      expect(page).to have_link(netsight_t(:sync_page))

      click_on netsight_t(:apply_vlans)
    end

    expect(page).to have_field("connection[vlans]", with: "t1192, t1194")
  end
end
