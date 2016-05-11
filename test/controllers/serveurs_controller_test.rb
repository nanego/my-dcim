require 'test_helper'

class ServeursControllerTest < ActionController::TestCase
  setup do
    sign_in users(:one)
    @serveur = serveurs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:serveurs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create serveur" do
    assert_difference('Serveur.count') do
      post :create, serveur: { acte_id: @serveur.acte_id, architecture_id: @serveur.architecture_id, armoire_id: @serveur.armoire_id, category_id: @serveur.categorie_id, cluster: @serveur.cluster, conso: @serveur.conso, critique: @serveur.critique, domaine_id: @serveur.domaine_id, fc_total: @serveur.fc_total, fc_utilise: @serveur.fc_utilise, gestion_id: @serveur.gestion_id, ilot: @serveur.ilot, ipmi_dedie: @serveur.ipmi_dedie, ipmi_futur: @serveur.ipmi_futur, ipmi_utilise: @serveur.ipmi_utilise, localisation_id: @serveur.localisation_id, marque_id: @serveur.marque_id, modele_id: @serveur.modele_id, nb_elts: @serveur.nb_elts, nom: @serveur.nom, numero: @serveur.numero, phase: @serveur.phase, rg45_cm: @serveur.rg45_cm, rj45_futur: @serveur.rj45_futur, rj45_total: @serveur.rj45_total, rj45_utilise: @serveur.rj45_utilise, baie_id: @serveur.baie_id, u: @serveur.u }
    end

    assert_redirected_to serveur_path(assigns(:serveur))
  end

  test "should show serveur" do
    get :show, id: @serveur
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @serveur
    assert_response :success
  end

  test "should update serveur" do
    patch :update, id: @serveur, serveur: { acte_id: @serveur.acte_id, architecture_id: @serveur.architecture_id, armoire_id: @serveur.armoire_id, categorie_id: @serveur.categorie_id, cluster: @serveur.cluster, conso: @serveur.conso, critique: @serveur.critique, domaine_id: @serveur.domaine_id, fc_total: @serveur.fc_total, fc_utilise: @serveur.fc_utilise, gestion_id: @serveur.gestion_id, ilot: @serveur.ilot, ipmi_dedie: @serveur.ipmi_dedie, ipmi_futur: @serveur.ipmi_futur, ipmi_utilise: @serveur.ipmi_utilise, localisation_id: @serveur.localisation_id, marque_id: @serveur.marque_id, modele_id: @serveur.modele_id, nb_elts: @serveur.nb_elts, nom: @serveur.nom, numero: @serveur.numero, phase: @serveur.phase, rg45_cm: @serveur.rg45_cm, rj45_futur: @serveur.rj45_futur, rj45_total: @serveur.rj45_total, rj45_utilise: @serveur.rj45_utilise, baie_id: @serveur.baie_id, u: @serveur.u }
    assert_redirected_to serveur_path(assigns(:serveur))
  end

  test "should destroy serveur" do
    assert_difference('Serveur.count', -1) do
      delete :destroy, id: @serveur
    end

    assert_redirected_to serveurs_path
  end
end
