# frozen_string_literal: true

module DeleteDependency
  class DocumentCollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= Document.model_name.human %></h4>
      <p><small>(<%= @asso_name %>)</small></p>
      <ul class="list-group" style="width: 18rem;">
        <% @docs.each do |doc| %>
          <%- next unless doc.document.present? %>
          <li class="list-group-item">
            <%= link_to(doc.document.metadata["filename"], doc.document_url, { target: :_blank })  %>
          </li>
        <% end %>
      </ul>
    ERB

    def initialize(docs, asso_name)
      @docs = docs
      @asso_name = asso_name
      super
    end

    private

    def show_link(record)
      link_to record.to_s, url_for(record), target: "_blank", rel: "noopener"
    rescue StandardError
      record.to_s
    end
  end
end
