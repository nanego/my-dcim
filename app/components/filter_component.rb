# frozen_string_literal: true

# TODO: use CardComponent
class FilterComponent < ApplicationComponent
  renders_one :form, ->(&block) { FilterComponent::Form.new(&block) }

  erb_template <<~ERB
    <div class="panel panel-primary">
      <div class="panel-heading">
        <h3 class="panel-title">Filtres</h3>
      </div>

      <%= form_with model: @filter, url: "", method: :get, class: "form-inline" do |f| %>
        <div class="panel-body">
          <%= form.call(f) %>
        </div>

        <div class="panel-footer">
          <%= f.submit "Filtrer", class: "btn btn-primary btn-sm" %>
          <%= link_to "Reset", url_for(only_path: false, overwrite_params: nil), class: "btn btn-secondary btn-sm" %>
        </div>
      <% end %>
    </div>
  ERB

  def initialize(filter)
    @filter = filter

    super()
  end

  class Form < ApplicationComponent
    delegate :call, to: :@block

    def initialize(&block)
      @block = block

      super()
    end
  end
end
