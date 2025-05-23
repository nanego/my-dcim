# frozen_string_literal: true

require "rails_helper"

RSpec.describe Breadcrumb do
  subject(:breadcrumb) { described_class.new }

  describe "#initialize" do
    subject(:breadcrumb) { described_class.new("root title", "/dashboard") }

    it { expect(breadcrumb.root_step.title).to eq("root title") }
    it { expect(breadcrumb.root_step.url).to eq("/dashboard") }
    it { expect(breadcrumb.steps).to eq([]) }

    context "with block given" do
      subject(:breadcrumb) do
        described_class.new("root title", "/dashboard") do |b|
          b.root("Home", "/")
          b.add_step("Servers", "/servers")
        end
      end

      it { expect(breadcrumb.root_step.title).to eq("Home") }
      it { expect(breadcrumb.root_step.url).to eq("/") }
      it { expect(breadcrumb.steps.first.title).to eq("Servers") }
      it { expect(breadcrumb.steps.first.url).to eq("/servers") }
      it { expect(breadcrumb.steps.size).to eq(1) }
    end
  end

  describe "#root" do
    before do
      breadcrumb.root("root title", "/dashboard")
    end

    it { expect(breadcrumb.root_step.title).to eq("root title") }
    it { expect(breadcrumb.root_step.url).to eq("/dashboard") }
  end

  describe "#add_step" do
    before do
      breadcrumb.add_step("Servers", "/servers")
    end

    it { expect(breadcrumb.steps.first.title).to eq("Servers") }
    it { expect(breadcrumb.steps.first.url).to eq("/servers") }
  end

  describe "#each_steps" do
    before do
      breadcrumb.add_step("Servers", "/servers")
      breadcrumb.add_step("Server #1", "/servers/1")
      breadcrumb.add_step("Edit")
    end

    it do
      expect { |b| breadcrumb.each_steps(&b) }
        .to yield_successive_args(Breadcrumb::Step, Breadcrumb::Step, Breadcrumb::Step)
    end

    it { expect(breadcrumb.steps.first.title).to eq("Servers") }
    it { expect(breadcrumb.steps.first.url).to eq("/servers") }
    it { expect(breadcrumb.steps.second.title).to eq("Server #1") }
    it { expect(breadcrumb.steps.second.url).to eq("/servers/1") }
    it { expect(breadcrumb.steps.third.title).to eq("Edit") }
    it { expect(breadcrumb.steps.third.url).to be_nil }
    it { expect(breadcrumb.steps.size).to eq(3) }
  end

  describe "#last" do
    before do
      breadcrumb.add_step("Servers", "/servers")
      breadcrumb.add_step("Server #1", "/servers/1")
      breadcrumb.add_step("Edit")
    end

    it do
      expect { |b| breadcrumb.each_steps(&b) }
        .to yield_successive_args(Breadcrumb::Step, Breadcrumb::Step, Breadcrumb::Step)
    end

    it { expect(breadcrumb.last.title).to eq("Edit") }
    it { expect(breadcrumb.last.url).to be_nil }
  end

  describe "#to_title" do
    before do
      breadcrumb.root("Home", "/")
      breadcrumb.add_step("Servers", "/servers")
      breadcrumb.add_step("Server #1", "/servers/1")
      breadcrumb.add_step("Edit")
    end

    it { expect(breadcrumb.to_title).to eq("Edit | Server #1 | Servers | Home") }
  end
end
