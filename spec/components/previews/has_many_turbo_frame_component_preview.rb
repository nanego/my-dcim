# frozen_string_literal: true

class HasManyTurboFrameComponentPreview < ViewComponent::Preview
  def default
    render(HasManyTurboFrameComponent.new(Server.model_name.human(count: 2), url: servers_path(frame_ids: Frame.first.id), frame_id: "table_server"))
  end

  def with_new_button
    render(HasManyTurboFrameComponent.new(
             Server.model_name.human(count: 2),
             url: servers_path(frame_ids: Frame.first.id),
             frame_id: "table_server",
             new_path: new_server_path,
             new_label: "Add a server",
           ))
  end
end
