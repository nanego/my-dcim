# frozen_string_literal: true

class DropServersFramesViews < ActiveRecord::Migration[8.0]
  def change
    drop_view :servers_frames_view, revert_to_version: 1
  end
end
