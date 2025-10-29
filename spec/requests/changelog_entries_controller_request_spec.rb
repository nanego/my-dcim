# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChangelogEntriesController do
  let(:object) { Color.create!(code: "FFFFFF") }
  let(:changelog_entry) { ChangelogEntry.create!(object: object, action: "create") }
  let(:admin_user) { users(:admin) }

  describe "GET #index" do
    subject(:response) do
      get changelog_entries_path

      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }

    it { expect { response }.to have_rubanok_processed(ChangelogEntry.all).with(ChangelogEntriesProcessor) }
  end

  describe "GET #show" do
    subject(:response) do
      get changelog_entry_path(changelog_entry)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    context "with not found changelog_entry" do
      let(:changelog_entry) { ChangelogEntry.new(id: 999_999_999) }

      it { expect { response }.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with existing changelog_entry" do
      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:show) }
    end
  end
end
