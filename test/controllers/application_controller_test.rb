# frozen_string_literal: true

require File.expand_path("../../test_helper", __FILE__)

class ApplicationControllerTest < ActionController::TestCase
  test "should test Application Controller" do
    controller = ApplicationController.new
    updated_object = Server.new(name: "SO-013", numero: "AZERTY4567")
    new_params = ActionController::Parameters.new({ name: "SO-013", numero: "AZERTY1234" })
    updated_values = controller.track_updated_values(updated_object, new_params)
    assert_equal updated_values, { "numero" => ["AZERTY4567", "AZERTY1234"] }
  end
end
