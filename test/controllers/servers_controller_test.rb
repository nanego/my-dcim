# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ServersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    Server.find_each(&:save)
    @server = servers(:one)
    @server2 = servers(:two)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:servers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create server" do
    assert_difference('Server.count') do
      post :create,
           params: {server: {cluster_id: @server.cluster_id, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero.to_s + '_bis', rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id}}
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test "should NOT create server with existing serial number" do
    assert_no_difference('Server.count') do
      post :create, params: {server: {cluster_id: @server.cluster_id, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id}}
    end
  end

  test "should show server" do
    get :show, params: {id: @server}
    assert_response :success
    assert_select 'dt', "Position :"
  end

  test "should show server using id" do
    get :show, params: {id: @server.id}
    assert_response :success
  end

  test "should show server using their name" do
    get :show, params: {id: @server.name}
    assert_response :success
  end

  test "should show server using serial number" do
    get :show, params: {id: @server.numero}
    assert_response :success
  end

  test "should get edit" do
    get :edit, params: {id: @server}
    assert_response :success
  end

  test "should update server" do
    patch :update, params: {id: @server, server: {cluster: @server.cluster, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, name: @server.name, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id}}
    assert_redirected_to server_path(assigns(:server))
  end

  test "should NOT update server if numero is a server name" do
    patch :update, params: {id: @server, server: {
        cluster: @server.cluster,
        critique: @server.critique,
        domaine_id: @server.domaine_id,
        fc_total: @server.fc_total,
        fc_utilise: @server.fc_utilise,
        gestion_id: @server.gestion_id,
        ipmi_dedie: @server.ipmi_dedie,
        ipmi_futur: @server.ipmi_futur,
        ipmi_utilise: @server.ipmi_utilise,
        modele_id: @server.modele_id,
        name: @server.name,
        numero: @server2.name, # forbidden number
        rj45_cm: @server.rj45_cm,
        rj45_futur: @server.rj45_futur,
        rj45_total: @server.rj45_total,
        rj45_utilise: @server.rj45_utilise,
        stack_id: @server.stack_id,
        frame_id: @server.frame_id}}
    assert_response 200
    assert_equal assigns(:server), @server
    assert_not_empty assigns(:server).errors.details[:numero]
  end

  test "should update server if numero is equal to own server name" do
    patch :update, params: {id: @server, server: {
        cluster: @server.cluster,
        critique: @server.critique,
        domaine_id: @server.domaine_id,
        fc_total: @server.fc_total,
        fc_utilise: @server.fc_utilise,
        gestion_id: @server.gestion_id,
        ipmi_dedie: @server.ipmi_dedie,
        ipmi_futur: @server.ipmi_futur,
        ipmi_utilise: @server.ipmi_utilise,
        modele_id: @server.modele_id,
        name: @server.name,
        numero: @server.name, # his name as a service number
        rj45_cm: @server.rj45_cm,
        rj45_futur: @server.rj45_futur,
        rj45_total: @server.rj45_total,
        rj45_utilise: @server.rj45_utilise,
        stack_id: @server.stack_id,
        frame_id: @server.frame_id}}
    assert_redirected_to server_path(assigns(:server))
    assert_empty assigns(:server).errors.details[:numero]
  end

  test "should rename a server" do
    new_name = "NewServerName"
    old_name = @server.name
    patch :update, params: {id: @server, server: {name: new_name}}
    assert_redirected_to server_path(assigns(:server))

    # test new name
    response = get :show, params: {id: new_name}
    assert_response :success
    assert_equal assigns(:server), @server

    #old name should continue to work
    get :show, params: {id: old_name}
    assert_response :success
    assert_equal assigns(:server), @server
  end

  test "should update cards in a server" do
    patch :update, params: {id: @server, server: {cards_attributes: {id:1,
                                                                     composant_id: 1,
                                                                     twin_card_id:2,
                                                                     orientation:"lr-td"}}}
    assert_redirected_to server_path(assigns(:server))

    # test new card
    response = get :show, params: {id: @server.name}
    assert_response :success
    assert_equal assigns(:server), @server

    card = Card.find(1)
    assert card.twin_card_id, 2

    # test twin card
    twin_card = Card.find(2)
    assert twin_card.twin_card_id, 1
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, params: {id: @server}
    end

    assert_redirected_to servers_grids_path
  end

  test "csv import" do
    test_file = Rails.root + "test/files/orders.csv"
    file = Rack::Test::UploadedFile.new(test_file)

    destination_frame = Frame.find_by_name('MyFrame2')
    assert destination_frame
    nb_of_servers_in_frame = destination_frame.servers.count

    assert_difference('Bay.count') do
      assert_difference('Frame.count') do

        assert_difference('Server.count', 26) do
          post :import, params: {import: {file: file,
                                          room_id: Room.first.id,
                                          server_state_id: ServerState.first.id}}
        end

      end
    end

    assert_response 302
    assert_redirected_to :controller => "frames", :action => "show", :id => "orders"
    assert_equal Server.find_by_numero('1234567AS').comment, "This is a comment"
    assert_equal destination_frame.reload.servers.count, nb_of_servers_in_frame + 4
    assert_equal destination_frame.servers.first.position, 30
    assert_equal Frame.where(name: 'orders').last.servers.count, 22
  end
end
