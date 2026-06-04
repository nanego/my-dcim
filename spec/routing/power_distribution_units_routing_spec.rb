# frozen_string_literal: true

require "rails_helper"

RSpec.describe PowerDistributionUnitsController do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/power_distribution_units").to route_to("power_distribution_units#index")
    end

    it "routes to #new" do
      expect(get: "/power_distribution_units/new").to route_to("power_distribution_units#new")
    end

    it "routes to #show" do
      expect(get: "/power_distribution_units/1").to route_to("power_distribution_units#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/power_distribution_units/1/edit").to route_to("power_distribution_units#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/power_distribution_units").to route_to("power_distribution_units#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/power_distribution_units/1").to route_to("power_distribution_units#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/power_distribution_units/1").to route_to("power_distribution_units#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/power_distribution_units/1").to route_to("power_distribution_units#destroy", id: "1")
    end
  end
end
