# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExternalAppRequest do
  let(:request) { described_class.new(user: users(:one), external_app_name: "glpi") }

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

  describe "#fail!" do
    before { request.save! }

    it { expect { request.fail!("boom") }.to change(request, :status).to("failed") }
    it { expect { request.fail!("x" * 600) }.to change { request.error_message.to_s.size }.to(500) }
  end

  describe ".stale and .active" do
    before { request.update!(status: :in_progress) }

    it { expect(described_class.active).to include(request) }

    it "considers a request without progress for too long as stale" do
      request.update_columns(updated_at: 11.minutes.ago) # rubocop:disable Rails/SkipsModelValidations

      expect(described_class.stale).to include(request)
    end
  end
end
