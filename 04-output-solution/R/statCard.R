# Stat Card Output Component - SOLUTION
# A metric display card with conditional styling

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
#'
#' @return A render function for use with statCardOutput
#' @export
renderStatCard <- function(expr) {
  # Modern pattern: capture expression as quosure and convert to function
  func <- shiny::quoToFunction(rlang::enquo0(expr))

  # Use createRenderFunction for proper Shiny integration
  shiny::createRenderFunction(
    func,
    transform = function(value, session, name, ...) {
      # Ensure we return the expected structure
      list(
        title = value$title,
        value = value$value,
        status = value$status
      )
    },
    outputFunc = statCardOutput
  )
}
