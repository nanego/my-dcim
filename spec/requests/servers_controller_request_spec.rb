# frozen_string_literal: true

require "rails_helper"

RSpec.describe ServersController do
  let(:server) { servers(:one) }
  let(:server2) { servers(:two) }
  let(:pdu) { servers(:pdu) }

  describe "GET #index" do
    subject(:response) do
      get servers_path(params)

      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { {} }

    include_context "with authenticated user"

    it_behaves_like "with preferred columns", ServersController::AVAILABLE_COLUMNS, route: :servers_path

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(server.name) }
    it { expect(response.body).to include(server2.name) }
    it { expect(response.body).not_to include(pdu.name) }

    it { expect { response }.to have_authorized_scope(:active_record_relation).with(ServerPolicy) }
    it { expect { response }.to have_rubanok_processed(Server.all).with(ServersProcessor) }

    context "when searching on name" do
      let(:params) { { q: "ServerName1" } }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(response.body).to include(server.name) }
      it { expect(response.body).not_to include(server2.name) }
    end
  end

  describe "GET #show" do
    subject(:response) do
      get server_path(server)
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated user"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:show) }
    it { expect(response.body).to include(server.name) }

    context "when using id" do
      before { get server_path(server.id) }

      it { expect(response).to have_http_status(:success) }
    end

    context "when using name" do
      before { get server_path(server.name) }

      it { expect(response).to render_template(:show) }
    end

    context "when using serial number" do
      before { get server_path(server.numero) }

      it { expect(response).to render_template(:show) }
    end

    context "with an id not set" do
      it { expect { get server_path("unknown-id") }.to raise_error(ActiveRecord::RecordNotFound) }
    end
  end

  describe "GET #new" do
    subject(:response) do
      get new_server_path
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET #duplicate" do
    subject(:response) do
      get duplicate_server_path(server)
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end

  describe "POST #create" do
    subject(:response) do
      post servers_path, params: params
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { server: valid_attributes } }
    let(:valid_attributes) do
      server.attributes.except(%w[id numero name]).merge(numero: "new_numero", name: "NewServerName")
    end

    include_context "with authenticated admin"

    context "with valid parameters" do
      it_behaves_like "with create another one"

      it do
        expect { response }.to change(Server, :count).by(1)
      end

      it do
        expect(response).to redirect_to(server_path(assigns(:server)))
      end
    end

    context "with invalid parameters" do
      let(:params) { { server: { name: "" } } }

      it { expect(response).to render_template(:new) }
    end

    context "without attributes" do
      let(:params) { { server: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end
  end

  describe "GET #edit" do
    subject(:response) do
      get edit_server_path(server)
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH #update" do
    subject(:response) do
      patch server_path(server), params: params
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:params) { { server: valid_attributes } }
    let(:valid_attributes) do
      server.attributes.except("name").merge(name: "New name")
    end

    include_context "with authenticated admin"

    context "with valid parameters" do
      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(server_path(server.reload)) }

      it do
        expect do
          response
          server.reload
        end.to change(server, :name).to("New name")
      end

      # old name should continue to work
      it do
        get server_path("ServerName1")
        expect(@response).to have_http_status(:success) # rubocop:disable RSpec/InstanceVariable
      end
    end

    context "with valid parameters, and an update on a card attributes" do
      let(:valid_attributes) do
        {
          name: server.name,
          cards_attributes: [{ composant_id: 1, twin_card_id: 2, orientation: "lr-td", card_type_id: 3 }],
        }
      end

      before { response }

      it { expect(response).to have_http_status(:redirect) }
      it { expect(response).to redirect_to(server_path(server.reload)) }

      # Test new card
      it { expect(Card.last.twin_card_id).to eq 2 }
      # Test twin card
      it { expect(Card.find(2).twin_card_id).to eq Card.last.id }
    end

    context "with invalid parameters" do
      let(:params) { { server: { name: "" } } }

      it { expect(response).to render_template(:edit) }
    end

    context "without attributes" do
      let(:params) { { server: {} } }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "without parameters" do
      let(:params) { {} }

      it { expect { response }.to raise_error(ActionController::ParameterMissing) }
    end

    context "when preview button clicked with turbo_stream format" do
      let(:params) do
        {
          server: { name: "Server#1" },
          preview: "preview",
          format: :turbo_stream,
        }
      end

      it { expect(response).to render_template(:preview) }
      it { expect(response).to have_http_status(:unprocessable_content) }
    end
  end

  describe "DELETE #destroy" do
    subject(:response) do
      delete server_path(server, confirm:, params:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:confirm) { nil }
    let(:params) { {} }

    include_context "with authenticated admin"

    context "without confirm" do
      let(:server) { server2 }

      it do
        expect { response }.not_to change(Server, :count)
      end

      it { expect(response).to have_http_status(:success) }
      it { expect(Server.exists?(server.id)).to be(true) }
    end

    context "with a server without association" do
      let(:confirm) { true }
      let(:server) { server2 }

      it { expect { response }.to change(Server, :count).by(-1) }
      it { expect(response).to redirect_to(servers_path) }

      context "with parameters" do
        let(:params) { { sort: "asc", sort_by: "rooms.name" } }

        it { expect(response).to redirect_to(servers_path({ sort: "asc", sort_by: "rooms.name" })) }
      end
    end

    context "with a server with association" do
      let(:confirm) { true }

      it { expect { response }.not_to change(Server, :count) }
      it { expect(response).to redirect_to(servers_path) }
    end
  end

  describe "GET #import_csv" do
    subject(:response) do
      get import_csv_servers_path
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    include_context "with authenticated admin"

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:import_csv) }
  end

  describe "POST #import" do
    subject(:response) do
      post import_servers_path, params: {
        import: { file: csv, room_id: Room.first.id },
      }
      # NOTE: used to simplify usage and custom test done in final spec file.
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:csv) { Rack::Test::UploadedFile.new(Rails.root.join("test/files/orders.csv").to_s) }
    let(:destination_frame) { Frame.find_by(name: "MyFrame2") }
    let(:nb_of_servers_in_frame) { destination_frame.servers.count }
    let(:frames_count) { Frame.where(name: "orders").last.servers.count }

    before { nb_of_servers_in_frame }

    include_context "with authenticated admin"

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect { response }.to change(Server, :count).by(26).and change(Frame, :count).and change(Bay, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(frame_path("orders"))
      expect(Server.find_by(numero: "1234567AS").comment).to eq "This is a comment"
      expect(destination_frame.servers.count).to eq(nb_of_servers_in_frame + 4)
      expect(destination_frame.servers.first.position).to eq 30
      expect(frames_count).to eq 22
    end
  end

  describe "GET #cables_export" do
    subject(:response) do
      get cables_export_server_path(server, format:)
      @response # rubocop:disable RSpec/InstanceVariable
    end

    let(:format) { nil }

    include_context "with authenticated admin"

    context "with pdf format" do
      let(:format) { :pdf }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:cables_export) }
      it { expect(response).to render_template("layouts/pdf") }
      it { expect(response.headers["Content-Type"]).to eq("application/pdf") }
    end

    context "without format" do
      it { expect { response }.to raise_error(ActionController::UnknownFormat) }
    end
  end
end
