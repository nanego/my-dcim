# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Servers::RackPosition", :js do
  let(:server) { servers(:one) }
  let(:user) { users(:admin) }

  def form_t(key, **) = I18n.t("servers.form.#{key}", locale: user.locale, **)

  before { modeles(:one).update!(u: 3) }

  it "shows the units occupied by the equipment while typing its position", :aggregate_failures do
    sign_in user

    visit edit_server_path(server)

    expect(page).to have_text(form_t(:rack_units_hint, units: "U37-39"))

    fill_in "server[position]", with: "12"
    expect(page).to have_text(form_t(:rack_units_hint, units: "U10-12"))

    fill_in "server[position]", with: ""
    expect(page).to have_text(form_t(:rack_units_empty_hint))
  end

  it "rejects a position overlapping another equipment", :aggregate_failures do
    sign_in user

    visit edit_server_path(server)
    fill_in "server[position]", with: "37"
    click_on I18n.t("helpers.submit.update", model: Server.model_name.human(locale: user.locale), locale: user.locale)

    # Modele one is now 3U high: U35-37 collides with servers(:two) (U36-38)
    overlap_error = I18n.t("activerecord.errors.models.server.attributes.position.overlaps",
                           units: "U35-37", servers: "", locale: user.locale)
    expect(page).to have_text(overlap_error.strip)
    expect(page).to have_text(servers(:two).name)
  end
end
