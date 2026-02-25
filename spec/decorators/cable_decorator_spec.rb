# frozen_string_literal: true

require "rails_helper"

RSpec.describe CableDecorator, type: :decorator do
  let(:cable) { cables(:one) }
  let(:decorated_cable) { cable.decorated }
  let(:user) { users(:admin) }

  describe ".servers_options_for_select" do
    it do
      expect(described_class.servers_options_for_select(user))
        .to contain_exactly(
          ["ReadableServer", 8], ["ServerName1", 1], ["ServerName2", 2], ["ServerName3", 740_841_338],
          ["ServerName4", 4], ["ServerName5", 5], ["ServerName6", 6],
        )
    end
  end

  describe ".special_case_options_for_select" do
    it { expect(described_class.special_case_options_for_select.pluck(1)).to contain_exactly(true, false) }
    it { expect(described_class.special_case_options_for_select.pluck(0)).to match_array(%w[Non Oui]) }
  end

  describe ".colors_options_for_select" do
    it { expect(described_class.colors_options_for_select.pluck(1)).to match_array(Cable::COLORS.keys) }
  end

  describe "#server_connected_with_link" do
    context "with from option to true" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(connections(:one), from: true) }

      it do
        is_expected.to have_tag("span.text-body-emphasis.col.overflow-wrap.text-end") do # rubocop:disable RSpec/ImplicitSubject
          with_tag("a.text-body-emphasis", text: servers(:one).name, with: { href: "/servers/1" })
          without_tag("span.fst-italic", text: "n/c")
        end
      end
    end

    context "with from option to false" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(connections(:one)) }

      it { is_expected.not_to have_tag("span.text-body-emphasis.col.overflow-wrap.text-end") }

      it do
        is_expected.to have_tag("span.text-body-emphasis.col.overflow-wrap") do # rubocop:disable RSpec/ImplicitSubject
          with_tag("a.text-body-emphasis", text: servers(:one).name, with: { href: "/servers/1" })
          without_tag("span.fst-italic", text: "n/c")
        end
      end
    end

    context "with a nil connection" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(nil) }

      it { is_expected.not_to have_tag("span.text-body-emphasis.col.overflow-wrap.text-end") }

      it do
        is_expected.to have_tag("span.text-body-emphasis.col.overflow-wrap") do # rubocop:disable RSpec/ImplicitSubject
          without_tag("a.text-body-emphasis")
          with_tag("span.fst-italic", text: "n/c")
        end
      end
    end
  end

  describe "#draw_port" do
    subject(:draw_port) { decorated_cable.draw_port(connection) }

    let(:connection) { connections(:one) }

    context "with a connection with a port" do
      it { is_expected.to have_tag("span.me-0.port.N.port.portSCSI", text: "cableXYZ") }
      it { is_expected.not_to have_tag("span.badge.empty", text: "n/c") }
    end

    context "without a connection" do
      subject(:draw_port) { decorated_cable.draw_port(nil) }

      it { is_expected.not_to have_tag("span.me-0.port") }
      it { is_expected.to have_tag("span.badge.empty", text: "n/c") }
    end

    context "with a cable with no name" do
      before { cable.name = "" }

      it { is_expected.to have_tag("span.me-0.port.N.port.portSCSI", text: "n/c") }
      it { is_expected.not_to have_tag("span.badge.empty", text: "n/c") }
    end

    context "with a connection with no port" do
      before { connection.port = nil }

      it { is_expected.not_to have_tag("span.me-0.port") }
      it { is_expected.to have_tag("span.badge.empty", text: "n/c") }
    end

    context "with a connection with a twin card cabled" do
      before { cards(:one).twin_card_id = 5 }

      it { is_expected.to have_tag("span.me-0.port.N.port.portSCSI", text: "cableXYZ") }
      it { is_expected.not_to have_tag("span.me-0.port.N.port.portSCSI.no_client", text: "cableXYZ") }
      it { is_expected.not_to have_tag("span.badge.empty", text: "n/c") }
    end

    context "with a connection with a twin card not cabled" do
      let(:cable) { cables(:three) }
      let(:connection) { connections(:four) }

      before do
        connection.port.card.update(twin_card_id: 1)
      end

      it { is_expected.to have_tag("span.me-0.port.T.port.portRJ.no_client", text: "T00") }
      it { is_expected.not_to have_tag("span.badge.empty", text: "n/c") }
    end
  end

  describe "#description" do
    it do
      expect(decorated_cable.description)
        .to eq("Connexion entre MyString ServerName1 (port #1) et MyString ServerName1 (port #2) => vlans:123a cablename:cableXYZ couleur:P")
    end
  end

  describe "#display_name" do
    it { expect(decorated_cable.display_name).to eq("cableXYZ (N)") }

    context "with nil name" do
      before { cable.name = nil }

      it { expect(decorated_cable.display_name).to eq("Câble#1 (N)") }
    end

    context "with empty name" do
      before { cable.name = "" }

      it { expect(decorated_cable.display_name).to eq("Câble#1 (N)") }
    end

    context "with no color" do
      before { cable.color = nil }

      it { expect(decorated_cable.display_name).to eq("cableXYZ (n/c)") }
    end

    context "with empty color" do
      before { cable.color = "" }

      it { expect(decorated_cable.display_name).to eq("cableXYZ (n/c)") }
    end
  end
end
