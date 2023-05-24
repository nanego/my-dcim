# frozen_string_literal: true

json.array! @maintainers, partial: 'maintainers/maintainer', as: :maintainer
