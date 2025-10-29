# frozen_string_literal: true

class DeleteDependencyComponent < ApplicationComponent
  erb_template <<~ERB
    <% if @restricting_records.empty? %>
      <p><%= t(".confirm") %></p>

      <%= render ButtonComponent.new(t("action.cancel"), url: :back, variant: :info, is_responsive: true) %>
      <%= render ButtonComponent.new(t("action.delete"), url: @confirmation_path, method: :delete, variant: :danger,
                                                         icon: :trash, is_responsive: true) %>
    <% end %>

    <% [
      {dep: @record_dependencies.restricted_with_error, grp_title: t(".restrict_dependency_title")},
      {dep: @record_dependencies.destroyable, grp_title: t(".destroy_dependency_title")},
    ].filter { |grp| !grp[:dep].empty? }.each do |group| %>
      <h2 class="mt-3"><%= group[:grp_title] %></h2>
      <div class="d-flex flex-wrap gap-3 mt-3">
        <% group[:dep].each do |dependency| %>
          <%= render CollectionComponent.new(dependency) %>
        <% end %>
      </div>
    <% end %>
  ERB

  def initialize(record, confirmation_path:, only: [], exept: [])
    @confirmation_path = confirmation_path
    @record_dependencies = RecordDependencies.new(record, only:, except:)

    super
  end

  class CollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <div>
        <h4><%= @dependency.klass.model_name.human %></h4>
        <p><small>(<%= @dependency.name %>)</small></p>

        <ul class="list-group" style="width: 18rem;">
          <% decorate(@dependency.records).each do |record| %>
            <li class="list-group-item">
              <%= record.display_name %>
            </li>
          <% end %>
        </ul>
      </div>
    ERB

    def initialize(dependency)
      @dependency = dependency

      super
    end
  end
end
