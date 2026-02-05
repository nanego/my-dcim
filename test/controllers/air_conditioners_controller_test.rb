# frozen_string_literal: true

require "test_helper"

class AirConditionersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @air_conditioner = air_conditioners(:one)
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
                                                                              air_conditioner_model: @air_conditioner.air_conditioner_model } }
    assert_redirected_to air_conditioner_path(@air_conditioner)
  end

  test "should destroy air_conditioner" do
    assert_difference("AirConditioner.count", -1) do
      delete air_conditioner_url(@air_conditioner, confirm: true)
    end

    assert_redirected_to air_conditioners_url
  end
end
