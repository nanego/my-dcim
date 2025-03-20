# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Breadcrumb do
  subject(:breadcrumb) { described_class.new }

  describe "#add" do
    pending
  end

  describe "#each_steps" do
    pending
  end

  describe "#to_s" do
    before do
      breadcrumb.add("Home", "/")
    end

    it { expect(breadcrumb.to_s).to eq("Home") }
  end
end
