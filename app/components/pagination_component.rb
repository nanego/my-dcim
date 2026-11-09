# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  erb_template <<~ERB
    <div class="pagination-component">
      <%== @pagy.series_nav(:bootstrap) %>

      <%= form_with url: url_for, method: :get, data: { controller: "form-update" },
                    class: "d-flex align-items-baseline gap-2" do |f| %>
        <%= helpers.hash_to_hidden_fields(query_parameters) %>

        <%= f.label @pagy.options[:limit_key], t(".items_per_page"), class: "form-label text-nowrap text-secondary" %>
        <%= f.select @pagy.options[:limit_key],
                     options_for_select(User::AVAILABLE_ITEMS_PER_PAGE, @pagy.limit),
                     {},
                     class: "form-select form-select-sm",
                     data: { action: "change->form-update#update" } %>
      <% end %>
    </div>
  ERB

  def initialize(pagy:, params: nil)
    @pagy = pagy
    @params = params

    super()
  end

  private

  def query_parameters
    (@params || request.query_parameters).merge(@pagy.options[:page_key] => 1)
  end
end
