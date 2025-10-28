# frozen_string_literal: true

class DeleteDependencyComponent < ApplicationComponent
  ALLOW_DEPEDENCY_OPTIONS = %i[
    restrict_with_error
    destroy
  ].freeze

  erb_template <<~ERB
    <% if @restricting_records.empty? %>

      <p><%= t(".confirm") %></p>

      <%= render ButtonComponent.new(
        t("action.cancel"),
        url: :back,
        variant: :info,
        is_responsive: true
      )%>

      <%= render ButtonComponent.new(
        t("action.delete"),
        url: @confirmation_path,
        method: :delete,
        variant: :danger,
        icon: "trash",
        is_responsive: true,
      )%>

      <% unless @destroy_records.empty? %>
        <p><%= t(".destroy_dependency_exist_message") %></p>
      <% end %>

    <% else %>
      <p><%= t(".restrict_dependency_exist_message") %></p>
    <% end %>

    <% dependencies = @restricting_records.empty? ? @destroy_records : @restricting_records %>
    <% unless dependencies.empty? %>

      <div class="d-flex flex-wrap gap-3">
        <% dependencies.each do |dependency| %>
          <div>
            <%= render CollectionComponent.new dependency[:association], dependency[:records] %>
          </div>
        <% end %>
      </div>

    <% end %>
  ERB

  def initialize(record, confirmation_path, only: nil, exept: nil)
    @confirmation_path = confirmation_path
    @only = only
    @exept = exept

    # restricting_records is a list of hashs with records
    # that prevent current record from being destroyed
    @restricting_records = []

    # destroy_records is also a list of hashs with records
    # but that will be destroyed if current record is
    @destroy_records = []

    fill_delete_dependencies(record)

    super
  end

  private

  def fill_delete_dependencies(record)
    record.class.reflect_on_all_associations.each do |a|
      # exclude according to config
      next unless association_counts?(a)

      asso_restricting = a.options[:dependent] == :restrict_with_error

      # don't fetch records if they are not restricting
      # and we already found other restricting records
      next if !asso_restricting && !@restricting_records.empty?

      # get records
      records = record.public_send(a.name)
      next if records.blank?

      # add in restrict or destroy
      asso_hash = { association: a, records: }
      if asso_restricting
        @restricting_records << asso_hash
      else
        @destroy_records << asso_hash
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

  class CollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= @asso.klass.model_name.human %></h4>
      <p><small>(<%= @asso.name %>)</small></p>
      <ul class="list-group" style="width: 18rem;">
        <% @records.each do |record| %>
          <li class="list-group-item">
            <%= show_link record %>
          </li>
        <% end %>
      </ul>
    ERB

    def initialize(asso, records)
      @asso = asso
      @records = records
      super
    end

    private

    def show_link(record)
      case record
      when Document
        link_to record.document.metadata["filename"], record.document_url, target: :_blank, rel: :noopener
      else
        link_to record.to_s, url_for(record), target: "_blank", rel: :noopener
      end
    rescue StandardError
      record.to_s
    end
  end
end
