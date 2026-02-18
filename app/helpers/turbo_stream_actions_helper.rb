# frozen_string_literal: true

module TurboStreamActionsHelper
  def frame_reload(frame_id)
    turbo_stream_action_tag(:frame_reload, target: frame_id)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
