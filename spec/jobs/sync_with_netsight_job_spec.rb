# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncWithNetsightJob do
  let!(:request) { ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight") }

  it "runs the synchronization and completes the request" do
    sync = instance_double(Netsight::Sync, call: nil)
    allow(Netsight::Sync).to receive(:new).with(request).and_return(sync)

    described_class.perform_now

    expect(request.reload).to have_attributes(status: "completed", progress: 100)
  end

  it "fails the request on error" do
    allow(Netsight::Sync).to receive(:new).and_raise(Netsight::Client::Error, "boom")

    described_class.perform_now

    expect(request.reload.status).to eq("failed")
  end
end
