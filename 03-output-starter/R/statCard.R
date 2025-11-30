# Stat Card Output Component
# A metric display card with conditional styling
#
# This file is COMPLETE - you don't need to modify it.
# Focus on completing the JavaScript binding in www/js/statcard.js

#' Create a stat card output dependency
#' @keywords internal
statCardDependency <- function() {
  htmltools::htmlDependency(
    name = "statcard",
    version = "1.0.0",
    src = c(file = normalizePath("www")),
    script = "js/statcard.js",
    stylesheet = "css/statcard.css"
  )
}

#' Create a stat card output placeholder
#'
#' @param outputId The output slot name
#' @param width The width of the card (CSS value)
#'
#' @return A stat card output container
#' @export
statCardOutput <- function(outputId, width = "200px") {
  htmltools::tagList(
    statCardDependency(),
    htmltools::tags$div(
      id = outputId,
      class = "stat-card",
      style = paste0("width: ", width, ";"),
      htmltools::tags$div(class = "stat-title", "Loading..."),
      htmltools::tags$div(class = "stat-value", "--")
    )
  )
}

#' Render a stat card
#'
#' @param expr An expression that returns a list with title, value, and status
#' @param env The environment in which to evaluate expr
#' @param quoted Is expr a quoted expression?
#'
#' @return A render function for use with statCardOutput
#' @export
renderStatCard <- function(expr, env = parent.frame(), quoted = FALSE) {
  # Convert expression to function
  func <- shiny::exprToFunction(expr, env, quoted)

  function() {
    val <- func()
    # Ensure we return the expected structure
    list(
      title = val$title,
      value = val$value,
      status = val$status
    )
  }
}
