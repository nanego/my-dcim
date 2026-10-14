# frozen_string_literal: true

require "rails_helper"

RSpec.describe GeocoderProxyUrl do
  subject(:client) { Geocoder::Lookup.get(:mapbox).send(:http_client) }

  around do |example|
    previous = Geocoder.config.slice(:http_proxy, :https_proxy)
    Geocoder.configure(http_proxy: proxy_url, https_proxy: proxy_url)
    example.run
  ensure
    Geocoder.configure(previous)
  end

  let(:proxy_url) { "http://dcim:p%40ss%3Aword@proxy.example.org:3128" }

  it { expect(client.proxy_address).to eq("proxy.example.org") }
  it { expect(client.proxy_port).to eq(3128) }
  it { expect(client.proxy_user).to eq("dcim") }
  it { expect(client.proxy_pass).to eq("p@ss:word") }

  context "without proxy" do
    let(:proxy_url) { nil }

    it { expect(client).to eq(Net::HTTP) }
  end
end
