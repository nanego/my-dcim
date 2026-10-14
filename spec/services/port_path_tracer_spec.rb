# frozen_string_literal: true

require "rails_helper"

RSpec.describe PortPathTracer, type: :service do
  subject(:result) { described_class.new.call(port) }

  let(:port) { Port.create!(position: 1, attachable: cards(:one)) }
  let(:patch_panel_port) { Port.create!(position: 2, attachable: cards(:four)) }
  let(:twin_port) { Port.create!(position: 2, attachable: cards(:five)) }
  let(:far_port) { Port.create!(position: 3, attachable: cards(:seven)) }

  def cable(port_a, port_b)
    cable = Cable.create!(name: "C#{port_a.id}")
    Connection.create!(cable:, port: port_a)
    Connection.create!(cable:, port: port_b)
  end

  context "with a direct cable" do
    before { cable(port, far_port) }

    it { expect(result).to have_attributes(status: :reached, end_port: far_port, hops: [far_port]) }
  end

  context "with a patch panel and its twin card in between" do
    before do
      cards(:four).update!(twin_card: cards(:five))
      cable(port, patch_panel_port)
      cable(twin_port, far_port)
    end

    it do
      expect(result).to have_attributes(status: :reached, end_port: far_port,
                                        hops: [patch_panel_port, twin_port, far_port])
    end
  end

  context "when the twin card port is not cabled" do
    before do
      cards(:four).update!(twin_card: cards(:five))
      cable(port, patch_panel_port)
      twin_port
    end

    it { expect(result).to have_attributes(status: :broken, end_port: nil, hops: [patch_panel_port, twin_port]) }
  end

  context "when the twin card has no port at that position" do
    before do
      cards(:four).update!(twin_card: cards(:five))
      cable(port, patch_panel_port)
    end

    it { expect(result).to have_attributes(status: :broken, hops: [patch_panel_port]) }
  end

  context "when the twin cards loop back" do
    before do
      cards(:four).update!(twin_card: cards(:five))
      cable(port, patch_panel_port)
      cable(twin_port, Port.create!(position: 2, attachable: cards(:four)))
    end

    it { expect(result.status).to eq(:broken) }
  end

  context "without any cable" do
    it { expect(result).to have_attributes(status: :not_cabled, hops: []) }
  end
end
