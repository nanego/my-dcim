// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

document.documentElement.setAttribute('data-bs-theme', (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'))

// import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

import jQuery from "jquery"
window.$ = window.jQuery = jQuery
// import "jquery-ui"

import Rails from "@rails/ujs"
Rails.start()

import "src"
