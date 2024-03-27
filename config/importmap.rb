# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin "new.application", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "stimulus-reveal-controller" # @4.1.0
pin "tom-select" # @2.3.1
pin "bootstrap" # @5.3.3
pin "@popperjs/core", to: "@popperjs--core.js" # @2.11.8

pin_all_from "app/javascript/controllers", under: "controllers"
pin "tom-select" # @1.7.8
