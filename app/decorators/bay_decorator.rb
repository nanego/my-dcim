# frozen_string_literal: true

class BayDecorator < ApplicationDecorator
  include ActionView::Context
  include ActionView::Helpers::AssetTagHelper
  include ActionView::Helpers::TextHelper

  class << self
    def access_control_options_for_select
      Bay.access_controls.keys.map { |a_c| [I18n.t("access_control.#{a_c}"), a_c] }
    end
  end

  def access_control_to_human
    return I18n.t("access_control.blank") unless (a_c = access_control.presence)

    I18n.t("access_control.#{a_c}")
  end

  def no_frame_warning_icon
    tag.span class: "bay-with-no-frame-warning ms-2" do
      concat(tag.span(class: "bi bi-exclamation-triangle-fill text-warning",
                      title: I18n.t(".bays.decorator.no_frame_warning_text"),
                      aria: { hidden: true },
                      data: { controller: "tooltip", bs_placement: "right" }))
      concat(tag.span(I18n.t(".bays.decorator.no_frame_warning_text"), class: "visually-hidden"))
    end
  end
end
