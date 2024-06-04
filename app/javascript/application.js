// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

// import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"

import LeaderLine from "leader-line"
window.LeaderLine = LeaderLine

import Rails from "@rails/ujs"
Rails.start()

import "src"
