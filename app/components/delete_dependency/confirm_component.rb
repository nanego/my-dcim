# frozen_string_literal: true

module DeleteDependency
  ALLOW_DEPEDENCY_OPTIONS = %i[
    restrict_with_error
    destroy
  ].freeze

  class ConfirmComponent < ApplicationComponent
    erb_template <<~ERB
      <% if @restrict.empty? %>

        <p><%= t(".confirm") %></p>

        <%= render ButtonComponent.new(
          t("action.cancel"),
          url: :back,
          variant: :info,
          is_responsive: true
        )%>

        <%= render ButtonComponent.new(
          t("action.delete"),
          url: @full_delete_path,
          method: :delete,
          variant: :danger,
          icon: "trash",
          is_responsive: true,
        )%>

        <% unless @destroy.empty? %>
          <p><%= t(".destroy_dependency_exist_message") %></p>
        <% end %>

      <% else %>
        <p><%= t(".restrict_dependency_exist_message") %></p>
      <% end %>

      <% dependencies = @restrict.empty? ? @destroy : @restrict %>
      <% unless dependencies.empty? %>

        <div class="d-flex flex-wrap gap-3">
          <% dependencies.each do |dependency| %>
            <div>
              <%= render component_for(dependency[:klass], dependency[:records], dependency[:asso_name]) %>
            </div>
          <% end %>
        </div>

      <% end %>
    ERB

    def initialize(record, full_delete_path, only: nil, exept: nil)
      @full_delete_path = full_delete_path
      @only = only
      @exept = exept

      compute_delete_dependencies(record)

      super
    end

    private

    def compute_delete_dependencies(record)
      @restrict = []
      @destroy = []

      record.class.reflect_on_all_associations.each do |a|
        # exclude according to config
        next unless association_counts?(a)

        asso_restricted = a.options[:dependent] == :restrict_with_error

        # don't fetch records if they don't restrict
        # and theu are other restricted records
        next if !asso_restricted && !@restrict.empty?

        # get records
        records = record.public_send(a.name)
        next if records.blank?

        # add in restrict or destroy
        asso_hash = {
          klass: a.klass,
          asso_name: a.name,
          records:,
        }

        if asso_restricted
          @restrict << asso_hash
        else
          @destroy << asso_hash
        end
      end
    end

    def association_counts?(asso)
      # only is above default config
      return @only.include?(asso.name) unless @only.nil?

      # default behavior
      return false unless ALLOW_DEPEDENCY_OPTIONS.include?(asso.options[:dependent])
      return false if %i[changelog_entries slugs].include? asso.name
      return false if asso.class_name.start_with?("ActiveStorage::")

      # exept is not above default config
      @expect.nil? || @expect.exclude?(asso.name)
    end

    def component_for(model, records, asso_name)
      class_name = "DeleteDependency::#{model.model_name.name}CollectionComponent"
      component_class = class_name.safe_constantize
      return component_class.new(records, asso_name) unless component_class.nil?

      DeleteDependency::DefaultsComponent.new model, records, asso_name
    end
  end
end
