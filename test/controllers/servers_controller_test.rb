require File.expand_path("../../test_helper", __FILE__)

class ServersControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @server = servers(:one)
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
      post :create, server: { acte_id: @server.acte_id, cluster: @server.cluster, conso: @server.conso, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, nom: @server.nom, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id }
    end

    assert_redirected_to server_path(assigns(:server))
  end

  test "should show server" do
    get :show, id: @server
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @server
    assert_response :success
  end

  test "should update server" do
    patch :update, id: @server, server: { acte_id: @server.acte_id, cluster: @server.cluster, conso: @server.conso, critique: @server.critique, domaine_id: @server.domaine_id, fc_total: @server.fc_total, fc_utilise: @server.fc_utilise, gestion_id: @server.gestion_id, ipmi_dedie: @server.ipmi_dedie, ipmi_futur: @server.ipmi_futur, ipmi_utilise: @server.ipmi_utilise, modele_id: @server.modele_id, nom: @server.nom, numero: @server.numero, rj45_cm: @server.rj45_cm, rj45_futur: @server.rj45_futur, rj45_total: @server.rj45_total, rj45_utilise: @server.rj45_utilise, frame_id: @server.frame_id }
    assert_redirected_to server_path(assigns(:server))
  end

  test "should destroy server" do
    assert_difference('Server.count', -1) do
      delete :destroy, id: @server
    end

    assert_redirected_to servers_path
  end
end
