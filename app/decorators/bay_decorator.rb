# frozen_string_literal: true

class BayDecorator < ApplicationDecorator
  include ActionView::Context
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TextHelper

  def no_frame_warning_icon
    tag.span class: "bay-with-no-frame-warning ms-2" do
      concat(tag.i class: "bi bi-exclamation-triangle-fill text-warning",
            title: I18n.t(".bays.decorator.no_frame_warning_text"),
            aria: { hidden: true },
            data: { controller: "tooltip", bs_placement: "right" })
      concat(tag.span I18n.t(".bays.decorator.no_frame_warning_text"), class: "visually-hidden")
    end
  end
end
