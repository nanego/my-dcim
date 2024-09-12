# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRequest do
  fixtures :users

  let(:request) { described_class.new(user: User.first, external_app_name: "glpi") }

  it "is valid with valid attributes" do
    expect(request).to be_valid
  end

  it "is not valid without a user" do
    request.user = nil
    expect(request).not_to be_valid
  end

  it "sets default status to pending" do
    expect(request.status).to eq("pending")
  end

  it "sets default progress to 0" do
    expect(request.progress).to eq(0)
  end
end
