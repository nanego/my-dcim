# frozen_string_literal: true

json.array! @disks, partial: 'disks/disk', as: :disk
