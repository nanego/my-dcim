require "test_helper"

class AirConditionersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
    @air_conditioner = air_conditioners(:one)
  end

  test "should get index" do
    get air_conditioners_url
    assert_response :success
  end

  test "should get new" do
    get new_air_conditioner_url
    assert_response :success
  end

  test "should create air_conditioner" do
    assert_difference("AirConditioner.count") do
      post air_conditioners_url, params: { air_conditioner: { bay_id: @air_conditioner.bay_id,
                                                              position: @air_conditioner.position,
                                                              last_service: @air_conditioner.last_service,
                                                              status: "on",
                                                              air_conditioner_model_id: @air_conditioner.air_conditioner_model_id,
                                                              name: @air_conditioner.name,
      } }
    end

    assert_redirected_to air_conditioners_url
  end

  test "should show air_conditioner" do
    get air_conditioner_url(@air_conditioner)
    assert_response :success
  end

  test "should get edit" do
    get edit_air_conditioner_url(@air_conditioner)
    assert_response :success
  end

  test "should update air_conditioner" do
    patch air_conditioner_url(@air_conditioner), params: { air_conditioner: { name: @air_conditioner.name,
                                                                              bay: @air_conditioner.bay,
                                                                              last_service: @air_conditioner.last_service,
                                                                              position: @air_conditioner.position,
                                                                              status: "on",
                                                                              air_conditioner_model: @air_conditioner.air_conditioner_model
    } }
    assert_redirected_to air_conditioners_url
  end

  test "should destroy air_conditioner" do
    assert_difference("AirConditioner.count", -1) do
      delete air_conditioner_url(@air_conditioner)
    end

    assert_redirected_to air_conditioners_url
  end
end
