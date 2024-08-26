require 'rails_helper'

RSpec.describe ExternalAppRequest, type: :model do

  fixtures :users

  let(:request) { ExternalAppRequest.new(user: User.first, external_app_name: 'glpi') }

  it "is valid with valid attributes" do
    expect(request).to be_valid
  end

  it "is not valid without a user" do
    request.user = nil
    expect(request).to_not be_valid
  end

  it "sets default status to pending" do
    expect(request.status).to eq("pending")
  end

  it "sets default progress to 0" do
    expect(request.progress).to eq(0)
  end
end
