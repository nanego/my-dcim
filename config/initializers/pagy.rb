# frozen_string_literal: true

# Pagy initializer
# See https://ddnexus.github.io/pagy/toolbox/configuration/initializer/

# Fallback limit; ApplicationController#pagy overrides it with the user's preference
Pagy::OPTIONS[:limit] = 100
# Let the client choose the limit through the "limit" param, up to this value
Pagy::OPTIONS[:client_limit] = 200 # User::AVAILABLE_ITEMS_PER_PAGE.max
# Number of page links in the nav: first, gap, 5 around the current page, gap, last
Pagy::OPTIONS[:slots] = 9

Pagy::OPTIONS.freeze
