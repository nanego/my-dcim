require 'rails_helper'

RSpec.describe SyncWithGlpiJob, type: :job do

  fixtures :users

  it "queues the job" do
    expect {
      SyncWithGlpiJob.perform_later
    }.to have_enqueued_job(SyncWithGlpiJob).on_queue('default')
  end

  it "executes perform" do
    request = ExternalAppRequest.create(user: User.first, external_app_name: 'glpi')

    expect {
      perform_enqueued_jobs { SyncWithGlpiJob.perform_later }
    }.to change { request.reload.progress }.from(0).to(100)
  end

  it "updates the request status and progress correctly" do
    request = ExternalAppRequest.create(user: User.first, external_app_name: 'glpi')

    perform_enqueued_jobs { SyncWithGlpiJob.perform_later }

    request.reload
    expect(request.status).to eq('completed')
    expect(request.progress).to eq(100)
  end
end
