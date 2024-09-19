// Import and register all your controllers from the importmap via controllers/**/*_controller
import { application } from "controllers/application"

import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Libraries
import RevealController from "@stimulus-components/reveal"

application.register("reveal", RevealController)
