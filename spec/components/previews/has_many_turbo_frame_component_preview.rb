# frozen_string_literal: true

class HasManyTurboFrameComponentPreview < ViewComponent::Preview
  def default
    render(HasManyTurboFrameComponent.new(Server.model_name.human(count: 2), url: servers_path(frame_ids: Frame.first.id), frame_id: "table_server"))
  end
end
