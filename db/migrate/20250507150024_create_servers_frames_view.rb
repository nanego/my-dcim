# frozen_string_literal: true

class CreateServersFramesView < ActiveRecord::Migration[8.0]
  def change
    create_view :servers_frames_view
  end
end
