# frozen_string_literal: true

class DeleteDependencyComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="col-12 col-md-10 col-lg-8 mx-auto">
      <%= render CollectionGroupComponent.with_collection(
        grouped_by_dependent, spacer_component: CollectionGroupSpacerComponent.new,
      ) %>

      <div class="col-12 py-4 mt-4 text-end sticky-bottom bg-body-tertiary border-top">
        <span class="d-inline-flex align-items-center me-auto">
          <%= render ButtonComponent.new(
            t("action.cancel"), url: :back, variant: :outline_secondary, extra_classes: "me-2"
          ) %>

          <%= render ButtonComponent.new(
            t("action.delete"),
            url: @confirmation_path,
            method: :delete,
            variant: :danger,
            extra_classes: class_names(disabled: @record_dependencies.restricted_with_error.any?)) %>
        </span>
      </div>
    </div>
  ERB

  def initialize(record, confirmation_path:, only: nil, except: nil)
    @confirmation_path = confirmation_path
    @record_dependencies = RecordDependencies.new(record, only:, except:)

    super
  end

  private

  def grouped_by_dependent
    {
      restrict_with_error: @record_dependencies.restricted_with_error,
      destroy: @record_dependencies.destroyable,
      }.to_a
  end

  class CollectionGroupComponent < ApplicationComponent
    TYPES = {
      restrict_with_error: :danger,
      destroy: :warning,
    }.freeze

    erb_template <<~ERB
      <div class="d-flex align-items-center justify-content-between sticky-top bg-body-tertiary p-2">
        <h5 class="m-0 text-<%= TYPES[@type] %>-emphasis"><%= t(".\#{@type}_dependency_title") %></h5>
        <span>
          <button class="btn btn-sm text-body-tertiary p-0"
                  title=<%= t(".show_all") %>
                  type="button"
                  data-bs-toggle="collapse"
                  data-bs-target=".collapse_<%= @type %>"
                  aria-expanded="false"
                  aria-controls="collapse <%= @type %>">
            <span class="bi bi-arrows-expand"></span>
          </button>
          |
          <button class="btn btn-sm text-body-tertiary p-0"
                  title=<%= t(".hide_all") %>
                  type="button"
                  data-bs-toggle="collapse"
                  data-bs-target=".collapse_<%= @type %>"
                  aria-expanded="false"
                  aria-controls="collapse <%= @type %>">
            <span class="bi bi-arrows-collapse"></span>
          </button>
        </span>
      </div>

      <%= render DeleteDependencyComponent::CollectionComponent.with_collection(@dependencies) %>
    ERB

    def initialize(collection_group:)
      @type = collection_group[0]
      @dependencies = collection_group[1]

      super()
    end

    def render?
      @dependencies.any?
    end
  end

  class CollectionGroupSpacerComponent < ApplicationComponent
    erb_template <<~ERB
      <hr class="mt-4 border-top opacity-100 ms-5">
    ERB
  end

  class CollectionComponent < ApplicationComponent
    with_collection_parameter :dependency

    TYPES = {
      restrict_with_error: :danger,
      destroy: :warning,
    }.freeze

    erb_template <<~ERB
      <%= render CardComponent.new(
        type: TYPES[@type],
        extra_classes: "bg-body-tertiary mt-2 ms-5"
      ) do |card| %>
        <% card.with_header do %>
          <div class="d-flex justify-content-between align-items-center btn-collapse cursor-pointer"
               data-bs-toggle="collapse"
               data-bs-target="#<%= @collapse_id %>"
               aria-expanded="false"
               aria-controls="<%= @collapse_id %>">
            <span><%= @dependency.title %>
              <small>(<span class="font-monospace"><%= records.length %></span>)</small>
            </span>
            <span class="bi bi-chevron-down text-white"></span>
          </div>
        <% end %>

        <% card.with_body(extra_classes: "p-0 collapse collapse_\#{@type}", id: @collapse_id) do %>
          <ul class="list-group list-group-flush">
            <% records.each do |record| %>
              <li class="list-group-item">
                <%= record.display_name %>
              </li>
            <% end %>
          </ul>
        <% end %>
      <% end %>
    ERB

    def initialize(dependency:)
      @dependency = dependency
      @type = dependency.type
      @collapse_id = "collapseCard-#{@dependency.name}"

      super
    end

    def records
      helpers.decorate(@dependency.records)
    rescue Dekorator::DecoratorNotFound
      helpers.decorate(@dependency.records, with: ApplicationDecorator)
    end
  end
end
