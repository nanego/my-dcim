# frozen_string_literal: true

require "rails_helper"

RSpec.describe BayDecorator, type: :decorator do
  let(:bay) { bays(:one) }
  let(:decorated_bay) { bay.decorated }

  describe "#no_frame_warning_icon" do
    subject(:warning_icon) { decorated_bay.no_frame_warning_icon }

    it { is_expected.to include("<span class=\"bay-with-no-frame-warning").once }
    it { is_expected.to include("<i class=\"bi bi-exclamation-triangle-fill").once }
    it { is_expected.to include("<span class=\"visually-hidden").once }
  end
end
