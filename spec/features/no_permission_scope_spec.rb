# frozen_string_literal: true

require "rails_helper"

RSpec.describe "No Permission Scope" do
  it "browse a page with a user without PermissionScope", :aggregate_failures do
    sign_in users(:without_permission_scope)

    visit root_path
    expect(page).to have_current_path(root_path)

    expect(first(".alert.alert-info > p").text).to eq("Permissions not configured")
  end
end
