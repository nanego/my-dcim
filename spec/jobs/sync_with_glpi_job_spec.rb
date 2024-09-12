# frozen_string_literal: true

require "rails_helper"

RSpec.describe SyncWithGlpiJob do
  let(:request) { ExternalAppRequest.create(user: User.first, external_app_name: "glpi") }

  before { request }

  it "queues the job" do
    expect do
      described_class.perform_later
    end.to have_enqueued_job(described_class).on_queue("default")
  end

  it "executes perform" do
    expect do
      perform_enqueued_jobs { described_class.perform_later }
    end.to change { request.reload.progress }.from(0).to(100)
  end

  describe "updates the request status and progress correctly" do
    before do
      perform_enqueued_jobs { described_class.perform_later }
      request.reload
    end

    it { expect(request.status).to eq("completed") }
    it { expect(request.progress).to eq(100) }
  end
end
