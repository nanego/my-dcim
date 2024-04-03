// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

document.documentElement.setAttribute('data-bs-theme', (window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light'))

// import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

import * as $ from "jquery"
window.$ = window.jQuery = $

import "jquery-ujs"
// import "jquery-ui"

import "src"
