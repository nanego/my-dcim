# frozen_string_literal: true

class DeleteDependencyComponent < ApplicationComponent
  erb_template <<~ERB
    <% if @record_dependencies.restricted_with_error.blank? %>
      <p><%= t(".confirm") %></p>

      <%= render ButtonComponent.new(t("action.cancel"), url: :back, variant: :info, is_responsive: true) %>
      <%= render ButtonComponent.new(t("action.delete"), url: @confirmation_path, method: :delete, variant: :danger,
                                                         icon: :trash, is_responsive: true) %>
    <% end %>

    <% [
      {dependencies: @record_dependencies.restricted_with_error, grp_title: t(".restrict_dependency_title")},
      {dependencies: @record_dependencies.destroyable, grp_title: t(".destroy_dependency_title")},
    ].filter { |grp| !grp[:dependencies].empty? }.each do |group| %>

      <h3 class="mt-5"><%= group[:grp_title] %></h3>
      <div class="d-flex flex-wrap gap-3 mt-3">
        <% group[:dependencies].each do |dependency| %>
          <%= render CollectionComponent.new(dependency) %>
        <% end %>
      </div>

    <% end %>
  ERB

  def initialize(record, confirmation_path:, only: nil, except: nil)
    @confirmation_path = confirmation_path
    @record_dependencies = RecordDependencies.new(record, only:, except:)

    super
  end

  class CollectionComponent < ApplicationComponent
    MAX_RECORD_TO_SHOW = 20

    erb_template <<~ERB
      <div>
        <h5><%= @dependency.title %></h5>
        <p><small>(<%= @dependency.name %>)</small></p>

        <ul class="list-group" style="width: 18rem;">
          <% records.slice(0, MAX_RECORD_TO_SHOW).each do |record| %>
            <li class="list-group-item overflow-hidden">
              <%= record.display_name %>
            </li>
          <% end %>
          <% if records.length > MAX_RECORD_TO_SHOW %>
            <li class="list-group-item">
              <%= t(".and_more", n_more: records.length - MAX_RECORD_TO_SHOW) %>
            </li>
          <% end %>
        </ul>
      </div>
    ERB

    def initialize(dependency)
      @dependency = dependency

      super
    end

    def records
      helpers.decorate(@dependency.records)
    rescue Dekorator::DecoratorNotFound
      helpers.decorate(@dependency.records, with: ApplicationDecorator)
    end
  end
end
