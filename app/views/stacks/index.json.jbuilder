# frozen_string_literal: true

json.array!(@stacks) do |stack|
  json.extract! stack, :id, :name, :color
  json.url stack_url(stack, format: :json)
end
