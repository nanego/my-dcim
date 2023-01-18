# frozen_string_literal: true

json.array! @memory_components, partial: 'memory_components/memory_component', as: :memory_component
