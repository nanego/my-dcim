# frozen_string_literal: true

require "rails_helper"

RSpec.describe CableDecorator, type: :decorator do
  let(:cable) { cables(:one) }
  let(:decorated_cable) { cable.decorated }

  describe ".special_case_options_for_select" do
    it { expect(described_class.special_case_options_for_select.pluck(1)).to contain_exactly(true, false) }
    it { expect(described_class.special_case_options_for_select.pluck(0)).to match_array(I18n.t("boolean").pluck(1)) }
  end

  describe ".colors_options_for_select" do
    it { expect(described_class.colors_options_for_select.pluck(1)).to match_array(Cable::COLORS.keys) }
  end

  describe "#server_connected_with_link" do
    context "with from option to true" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(connections(:one), from: true) }

      it do
        is_expected.to have_tag("span.text-body-emphasis.col.overflow-wrap.text-end") do # rubocop:disable RSpec/ImplicitSubject
          with_tag("a.text-body-emphasis", href: "/servers/1", text: servers(:one).name)
          without_tag("span.fst-italic", text: "n/c")
        end
      end
    end

    context "with from option to false" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(connections(:one)) }

      it { is_expected.not_to have_tag("span.text-body-emphasis.col.overflow-wrap.text-end") }

      it do
        is_expected.to have_tag("span.text-body-emphasis.col.overflow-wrap") do # rubocop:disable RSpec/ImplicitSubject
          with_tag("a.text-body-emphasis", href: "/servers/1", text: servers(:one).name)
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

    context "with a connection without server" do
      subject(:server_connected_with_link) { decorated_cable.server_connected_with_link(connections(:five)) }

      before { servers(:four).delete }

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

      it { is_expected.not_to have_tag("span.me-0.port") }
      it { is_expected.to have_tag("span.badge.empty", text: "n/c") }
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
end
