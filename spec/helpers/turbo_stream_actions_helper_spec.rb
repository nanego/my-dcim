# frozen_string_literal: true

require "rails_helper"

RSpec.describe TurboStreamActionsHelper do
  include RSpecHtmlMatchers

  describe "frame_reload" do
    it do
      expect(helper.frame_reload("my-frame"))
        .to have_tag("turbo-stream", with: { action: "frame_reload", target: "my-frame" })
    end
  end
end
