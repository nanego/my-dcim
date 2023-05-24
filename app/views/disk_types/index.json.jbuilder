# frozen_string_literal: true

json.array! @disk_types, partial: 'disk_types/disk_type', as: :disk_type
