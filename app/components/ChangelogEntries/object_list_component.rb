# frozen_string_literal: true

module ChangelogEntries
  class ObjectListComponent < ApplicationComponent
    include Turbo::FramesHelper

    erb_template <<~ERB
      <%= turbo_frame_tag("changelog-entries", loading: :lazy, src: object_changelog_path, **@html_options) do %>
        <div class="w-100 d-flex justify-content-center align-items-center gap-3">
          <span><%= t("changelog_entries.object_list_component.loading") %></span>
          <span class="spinner-border spinner-border-sm p-4"></span>
        </div>
      <% end %>
    ERB

    def initialize(object, **html_options)
      @object = object
      @html_options = html_options

      raise ArgumentError, "@object could not be nil" unless @object

      super()
    end

    private

    def object_changelog_path
      object_changelog_entries_path(@object.model_name.plural, @object.id)
    end
  end
end
