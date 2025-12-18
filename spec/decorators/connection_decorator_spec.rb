# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConnectionDecorator, type: :decorator do
  let(:connection) { connections(:one) }
  let(:decorated_connection) { connection.decorated }

  describe "#display_name" do
    it { expect(decorated_connection.display_name).to eq("ServerName1 - Carte ServerName1 / Card1 / compo1") }
  end
end
