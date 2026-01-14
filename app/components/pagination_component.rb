# frozen_string_literal: true

class PaginationComponent < ApplicationComponent
  include Pagy::Frontend

  erb_template <<~ERB
    <div class="pagination-component">
      <%== pagy_bootstrap_nav(@pagy) %>

      <%= form_with url: url_for(toto: true), method: :get, data: { controller: "form-update" },
                    class: "d-flex align-items-baseline gap-2" do |f| %>
        <%= helpers.hash_to_hidden_fields(query_parameters) %>

        <%= f.label @pagy.vars[:limit_param], t(".items_per_page"), class: "form-label text-nowrap text-secondary" %>
        <%= f.select @pagy.vars[:limit_param], options_for_select(User::AVAILABLE_ITEMS_PER_PAGE, @pagy.limit),
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
    (@params || request.query_parameters).merge(@pagy.vars[:page_param] => 1)
  end
end
