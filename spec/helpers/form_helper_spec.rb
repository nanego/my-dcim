# frozen_string_literal: true

require "rails_helper"

RSpec.describe FormHelper do
  let(:param_redirect) { nil }

  describe "#redirect_to_on_success_hidden_field_tag" do
    context "when params[:redirect_to_on_success] is nil" do
      it { expect(helper.redirect_to_on_success_hidden_field_tag(param_redirect)).to be_nil }
    end

    context "when when params[:redirect_to_on_success] is set" do
      let(:param_redirect) { users_path }

      it do
        expect(helper.redirect_to_on_success_hidden_field_tag(param_redirect)).to eq(
          "<input type=\"hidden\" name=\"redirect_to_on_success\" id=\"redirect_to_on_success\" value=\"/users\" autocomplete=\"off\" />",
        )
      end
    end
  end

  describe "#pagy_to_hidden_fields" do
    let(:pagy) { Pagy.new(count: 1, limit: 50) }

    it do
      expect(helper.pagy_to_hidden_fields(pagy)).to eq <<~HTML.chomp
        <input type="hidden" name="limit" value="50" autocomplete="off" />
      HTML
    end
  end

  describe "#query_parameters_to_hidden_fields" do
    it { expect(helper.query_parameters_to_hidden_fields).to eq("") }
  end

  describe "#hash_to_hidden_fields" do
    let(:hash) { { key: "value", array: [1, 2], hash: { k1: :v1, k2: :v2 }, empty: nil } }

    it do # rubocop:disable RSpec/ExampleLength
      expect(helper.hash_to_hidden_fields(hash)).to eq <<~HTML.chomp
        <input type="hidden" name="array[]" value="1" autocomplete="off" />
        <input type="hidden" name="array[]" value="2" autocomplete="off" />
        <input type="hidden" name="hash[k1]" value="v1" autocomplete="off" />
        <input type="hidden" name="hash[k2]" value="v2" autocomplete="off" />
        <input type="hidden" name="key" value="value" autocomplete="off" />
      HTML
    end
  end
end
