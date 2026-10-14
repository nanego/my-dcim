# frozen_string_literal: true

require "rails_helper"

RSpec.describe NetsightSyncResultsHelper do
  describe "#netsight_dcim_port_tag" do
    it "draws the port like the rack views" do
      expect(helper.netsight_dcim_port_tag(ports(:four)))
        .to have_css(".js_connection_edit_port a.port[href='#{connections_edit_path(from_port_id: ports(:four).id)}']")
    end
  end

  describe "#netsight_result_action" do
    subject(:action) { helper.netsight_result_action(result) }

    let(:request) { ExternalAppRequest.create!(user: users(:admin), external_app_name: "netsight") }
    let(:port) { ports(:four) }
    let(:result) do
      NetsightSyncResult.new(external_app_request: request, server: servers(:one), port:, kind:, status:,
                             dcim_value: port.vlans, netsight_value: "u201")
    end

    before { allow(helper).to receive(:allowed_to?).and_return(true) }

    context "with an action run from this page" do
      let(:kind) { :vlan }
      let(:status) { :differs }

      it { expect(action).to have_button(I18n.t("netsight_sync_results.index.apply")) }

      it "explains what the button changes" do
        expect(action).to have_css("button[title*='u201'][data-controller='tooltip']")
      end
    end

    context "with an action on the connection page" do
      let(:kind) { :link }
      let(:status) { :not_cabled_in_dcim }

      it { expect(action).to have_link(href: connections_edit_path(from_port_id: port.id)) }
      it { expect(action).to have_css("a.js_connection_edit_link_to[data-url]") }
      it { expect(action).not_to have_button }
    end

    context "with an action on the switch edit page" do
      let(:kind) { :switch }
      let(:status) { :name_serial_mismatch }

      it { expect(action).to have_link(href: edit_server_path(servers(:one))) }
    end

    context "with nothing to click" do
      let(:kind) { :switch }
      let(:status) { :netsight_unreachable }

      it { expect(action).to include(I18n.t("netsight_sync_results.index.notes.netsight_unreachable")) }
    end

    context "with nothing to do" do
      let(:kind) { :link }
      let(:status) { :matches }

      it { expect(action).to be_nil }
    end
  end

  describe "#netsight_vlans_tag" do
    it { expect(helper.netsight_vlans_tag("u201, t1192")).to eq("u201, t1192") }
    it { expect(helper.netsight_vlans_tag("u1629,t1754 t1656")).to eq("u1629, t1754, t1656") }
    it { expect(helper.netsight_vlans_tag("f1 port5")).to eq(%(<span class="text-break">f1 port5</span>)) }

    it "shortens a long list and keeps it in a tooltip" do
      vlans = (1..10).map { |i| "t#{i}" }.join(", ")

      expect(helper.netsight_vlans_tag(vlans)).to eq(%(<span title="#{vlans}">t1, t2, t3, t4, t5, t6, t7, t8, … (10)</span>))
    end
  end
end
