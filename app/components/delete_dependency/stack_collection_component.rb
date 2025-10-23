# frozen_string_literal: true

module DeleteDependency
  class StackCollectionComponent < ApplicationComponent
    erb_template <<~ERB
      <h4 class="mt-5"><%= Stack.model_name.human %></h4>
      <table class="table">
        <thead>
          <tr>
            <th scope="col"><%= Stack.human_attribute_name(:name) %></th>
            <th scope="col"><%= Stack.human_attribute_name(:color) %></th>
            <th scope="col"><%= Stack.human_attribute_name(:servers) %></th>
          </tr>
        </thead>
        <tbody>
          <% @stacks.each do |stack| %>
            <tr>
              <th scope="row"><%= link_to stack, stack_path(stack), target: "_blank" %></th>
              <td><%= stack.color %></td>
              <td><%= link_to Stack.human_attribute_name(:servers_count, count: stack.servers_count),
                  servers_path(stack_ids: stack.id), target: "_blank" %></td>
            </tr>
          <% end %>
        </tbody>
      </table>
    ERB

    def initialize(stacks)
      @stacks = stacks
      super
    end
  end
end
