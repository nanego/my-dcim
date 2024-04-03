# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "new.application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "stimulus-reveal-controller" # @4.1.0
pin "tom-select" # @2.3.1
pin "leader-line" # @1.0.5
pin "sortablejs" # @1.14.0
pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.js", preload: true
pin "jquery", preload: true # @3.7.0
pin "jquery-ujs", preload: true # @1.2.3
# pin "jquery-ui", preload: true # @1.13.0

pin_all_from "app/javascript/controllers", under: "controllers"
pin_all_from "app/javascript/src", under: "src", to: "src"
