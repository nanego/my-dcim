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
end
