# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitTypesController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/power_distribution_unit_types").to route_to("power_distribution_unit_types#index")
    end

    it "routes to #new" do
      expect(get: "/power_distribution_unit_types/new").to route_to("power_distribution_unit_types#new")
    end

    it "routes to #show" do
      expect(get: "/power_distribution_unit_types/1").to route_to("power_distribution_unit_types#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/power_distribution_unit_types/1/edit").to route_to("power_distribution_unit_types#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/power_distribution_unit_types").to route_to("power_distribution_unit_types#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/power_distribution_unit_types/1").to route_to("power_distribution_unit_types#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/power_distribution_unit_types/1").to route_to("power_distribution_unit_types#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/power_distribution_unit_types/1").to route_to("power_distribution_unit_types#destroy", id: "1")
    end
  end
end
