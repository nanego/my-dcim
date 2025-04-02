# frozen_string_literal: true

require "rails_helper"

RSpec.describe PortTypeDecorator, type: :decorator do
  let(:port_type) { port_types(:one) }
  let(:decorated_port_type) { port_type.decorated }

  describe "#css_class_name" do
    subject(:css_class_name) { decorated_port_type.css_class_name }

    context "with port type is FC" do
      it { is_expected.to eq("portFC") }
    end

    context "with port type is SC" do
      before { port_type.name = "SC" }

      it { is_expected.to eq("portFC") }
    end

    context "with port type is RJ" do
      before { port_type.name = "RJ" }

      it { is_expected.to eq("portRJ") }
    end

    context "with port type is XRJ" do
      before { port_type.name = "XRJ" }

      it { is_expected.to eq("portRJ") }
    end

    context "with port type is ALIM" do
      before { port_type.name = "ALIM" }

      it { is_expected.to eq("portALIM") }
    end

    context "with port type is SCSI" do
      before { port_type.name = "SCSI" }

      it { is_expected.to eq("portSCSI") }
    end

    context "with port type is Anything_else" do
      before { port_type.name = "Anything_else" }

      it { is_expected.to eq("portSCSI") }
    end
  end
end
