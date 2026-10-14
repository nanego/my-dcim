# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ExternalAppRecords::Sync", :js do
  let(:user) { users(:admin) }

  def page_t(key, **) = I18n.t("external_app_records.index.#{key}", locale: user.locale, **)

  before { sign_in user }

  it "starts a synchronization" do
    visit external_app_records_path

    click_on page_t(:start_synchronization)

    expect(page).to have_text(page_t(:synchronizing))
  end
end
