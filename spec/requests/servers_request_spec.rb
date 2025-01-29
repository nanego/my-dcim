# frozen_string_literal: true

require "rails_helper"

RSpec.describe "/servers" do
  let(:server) { servers(:one) }
  let(:server2) { servers(:two) }

  before do
    sign_in users(:one)

    server.save!
    server2.save!
  end

  describe "GET /index" do
    before { get servers_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:index) }
    it { expect(response.body).to include(server.name) }
    it { expect(response.body).to include(server2.name) }

    context "when searching on name" do
      before { get servers_path(q: "ServerName1") }

      it { expect(response).to have_http_status(:success) }
      it { expect(response).to render_template(:index) }
      it { expect(response.body).to include(server.name) }
      it { expect(response.body).not_to include(server2.name) }
    end
  end

  describe "GET /show" do
    before { get server_path(server) }

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

  describe "GET /new" do
    before { get new_server_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:new) }
  end

  describe "GET /duplicate" do
    before { get duplicate_server_path(server) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:duplicate) }
  end

  describe "POST /create" do
    context "with valid parameters" do
      let(:valid_attributes) do
        server.attributes.except(["id", "numero", "name"]).merge(numero: "new_numero", name: "NewServerName")
      end

      it "creates a new Server" do
        expect do
          post servers_path, params: { server: valid_attributes }
        end.to change(Server, :count).by(1)
      end

      it "redirects to the created server" do
        post servers_path, params: { server: valid_attributes }
        expect(response).to redirect_to(server_path(assigns(:server)))
      end
    end

    context "with invalid parameters" do
      let(:invalid_attributes) { { name: "" } }

      it "does not create a new Server without attributes" do
        expect { post servers_path, params: { server: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new Server without parameters" do
        expect { post servers_path, params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not create a new Server with invalid parameters" do
        post servers_path, params: { server: invalid_attributes }
        expect(response).to render_template(:new)
      end
    end
  end

  describe "GET /edit" do
    before { get edit_server_path(server) }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:edit) }
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { server.attributes.except("name").merge(name: "New name") }

      it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch server_path(server), params: { server: new_attributes }
        server.reload
        assigns(:server).reload

        expect(response).to be_redirection
        expect(response).to redirect_to(server_path(assigns(:server)))
        expect(server.name).to eq(new_attributes[:name])

        # old name should continue to work
        get server_path("ServerName1")
        expect(response).to have_http_status(:success)
        expect(server).to eq(assigns(:server))
      end

      it "does update cards in a server", :aggregate_failures do # rubocop:disable RSpec/ExampleLength
        patch server_path(server), params: { server: { cards_attributes: { id: 1,
                                                                           composant_id: 1,
                                                                           twin_card_id: 2,
                                                                           orientation: "lr-td" } } }

        assigns(:server).reload
        server.reload

        expect(response).to be_redirection
        expect(response).to redirect_to(server_path(assigns(:server)))

        # Test new card
        get server_path(server)
        expect(response).to have_http_status(:success)
        expect(server).to eq(assigns(:server))
        expect(Card.find(1).twin_card_id).to eq 2

        # Test twin card
        expect(Card.find(2).twin_card_id).to eq 1
      end
    end

    context "with invalid parameters" do
      it "does not update a Server without attributes" do
        expect { patch server_path(server), params: { server: {} } }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Server without parameters" do
        expect { patch server_path(server), params: {} }
          .to raise_error(ActionController::ParameterMissing)
      end

      it "does not update a Server with invalid parameters", :aggregate_failures do
        patch server_path(server), params: { server: { name: "" } }

        expect(response).to render_template(:edit)
      end
    end
  end

  describe "DELETE /destroy" do
    context "with a server without association" do
      it "destroys the requested server" do
        expect do
          delete server_path(server2)
        end.to change(Server, :count).by(-1)
      end

      it "redirects to the servers list" do
        delete server_path(server2)
        expect(response).to redirect_to(servers_path)
      end

      it "redirects to the servers list and keep params" do
        delete server_path(server2, params: { sort: "asc", sort_by: "rooms.name" })
        expect(response).to redirect_to(servers_path({ sort: "asc", sort_by: "rooms.name" }))
      end
    end

    context "with a server with association" do
      it "does not destroy the requested server" do
        expect do
          delete server_path(server)
        end.not_to change(Server, :count)
      end

      it "redirects to the servers list" do
        delete server_path(server)
        expect(response).to redirect_to(servers_path)
      end
    end
  end

  describe "GET /import_csv" do
    fixtures :server_states

    before { get import_csv_servers_path }

    it { expect(response).to have_http_status(:success) }
    it { expect(response).to render_template(:import_csv) }
  end

  describe "POST /import" do
    let(:csv) { Rack::Test::UploadedFile.new("#{Rails.root}/test/files/orders.csv") }
    let(:destination_frame) { Frame.find_by(name: 'MyFrame2') }
    let(:nb_of_servers_in_frame) { destination_frame.servers.count }
    let(:frames_count) { Frame.where(name: 'orders').last.servers.count }

    before { nb_of_servers_in_frame }

    it :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect do
        post import_servers_path, params: {
          import: { file: csv, room_id: Room.first.id, server_state_id: ServerState.first.id }
        }
      end.to change(Server, :count).by(26).and change(Frame, :count).and change(Bay, :count)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(frame_path("orders"))
      expect(Server.find_by(numero: '1234567AS').comment).to eq "This is a comment"
      expect(destination_frame.servers.count).to eq(nb_of_servers_in_frame + 4)
      expect(destination_frame.servers.first.position).to eq 30
      expect(frames_count).to eq 22
    end
  end

  describe "GET /destroy_connections" do
    before { get destroy_connections_server_path(server) }

    it { expect(response).to have_http_status(:redirect) }
    it { expect(server.connections.count).to be_zero }
    it { expect(flash[:notice]).to be_present }
  end
end
