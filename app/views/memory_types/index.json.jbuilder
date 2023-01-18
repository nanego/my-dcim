# frozen_string_literal: true

json.array! @memory_types, partial: 'memory_types/memory_type', as: :memory_type
